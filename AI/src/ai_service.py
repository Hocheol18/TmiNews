from flask import Flask, request, jsonify
import json
import requests
import os
import logging
from dotenv import load_dotenv

# 로깅 설정
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# .env 파일 로드 (프로젝트 루트에 위치)
dotenv_path = os.path.join(os.path.dirname(__file__), "..", "..", ".env")
load_dotenv(dotenv_path)

app = Flask(__name__)

UPSTAGE_API_URL = "https://api.upstage.ai/v1/chat/completions"
UPSTAGE_API_TOKEN = os.environ.get("UPSTAGE_API_TOKEN", "UPSTAGE_TOKEN")

def build_prompt(title: str, content: str, category: str, min_title_words: int = 10, min_content_words: int = 200) -> str:
    """
    뉴스 기사 스타일의 제목과 본문 생성을 위한 프롬프트를 구성합니다.
    최소 제목 단어 수와 본문 단어 수 조건을 포함시킬 수 있습니다.
    """
    prompt = (
        f"카테고리: {category}\n"
        f"제목: {title}\n"
        f"내용: {content}\n"
        "위 내용을 기반으로 뉴스 기사 스타일의 제목과 본문을 생성해줘. "
        f"제목은 최소 {min_title_words}단어 이상, 본문은 최소 {min_content_words}단어 이상 작성해줘. "
        "응답은 JSON 형식으로 {\"generated_title\": \"...\", \"generated_content\": \"...\"} 형태로 해줘."
    )
    return prompt

@app.route("/generate", methods=["POST"])
def generate():
    try:
        data = request.get_json(force=True)
    except Exception as e:
        logger.error(f"JSON 파싱 에러: {e}")
        return jsonify({"error": "유효한 JSON 데이터를 전송해주세요."}), 400

    # 기본값 처리 및 데이터 검증
    title = data.get("title", "").strip()
    content = data.get("content", "").strip()
    category = data.get("category", "").strip()
    
    if not title or not content or not category:
        return jsonify({"error": "title, content, category 값은 필수입니다."}), 400

    # 프롬프트 생성 (필요에 따라 최소 길이 조건 조정)
    prompt_text = build_prompt(title, content, category)

    headers = {
        "Authorization": f"Bearer {UPSTAGE_API_TOKEN}",
        "Content-Type": "application/json"
    }
    payload = {
        "model": "solar-pro",  # 사용할 모델 이름
        "messages": [
            {
                "role": "user",
                "content": prompt_text
            }
        ]
    }
    
    try:
        response = requests.post(UPSTAGE_API_URL, json=payload, headers=headers, timeout=10)
    except requests.exceptions.RequestException as e:
        logger.error(f"API 요청 실패: {e}")
        return jsonify({"error": "AI 서비스 요청에 실패했습니다."}), 500

    if response.status_code == 200:
        try:
            resp_data = response.json()
            # Upstage 응답에서 choices[0].message.content에 JSON 문자열이 담겨있다고 가정
            choice = resp_data.get("choices", [])[0]
            message = choice.get("message", {})
            content_str = message.get("content", "")
            result = json.loads(content_str)
            generated_title = result.get("generated_title", "AI 제목 생성 실패")
            generated_content = result.get("generated_content", "AI 본문 생성 실패")
        except Exception as e:
            logger.error(f"응답 파싱 에러: {e}")
            generated_title = "[ERROR] 파싱 실패"
            generated_content = f"응답 파싱 중 오류 발생: {str(e)}"
    else:
        logger.error(f"AI 생성 실패 - Status Code: {response.status_code}, Response: {response.text}")
        generated_title = "[ERROR] AI 생성 실패"
        generated_content = f"Status Code: {response.status_code}, {response.text}"

    return jsonify({
        "generated_title": generated_title,
        "generated_content": generated_content
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
