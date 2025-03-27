
from flask import Flask, request, jsonify
import json
import requests
import os

app = Flask(__name__)

UPSTAGE_API_URL = "https://api.upstage.ai/v1/chat/completions"
UPSTAGE_API_TOKEN = os.environ.get("UPSTAGE_API_TOKEN", "YOUR_UPSTAGE_TOKEN")

@app.route("/generate", methods=["POST"])
def generate():
    data = request.json
    title = data.get("title", "")
    content = data.get("content", "")
    category = data.get("category", "")

    # 프롬프트 구성: 뉴스 기사 스타일의 제목과 본문을 JSON 형태로 응답해달라고 요청합니다.
    prompt_text = (
        f"카테고리: {category}\n"
        f"제목: {title}\n"
        f"내용: {content}\n"
        "위 내용을 기반으로 뉴스 기사 스타일의 제목과 본문을 생성해줘. "
        "응답은 JSON 형식으로 {\"generated_title\": \"...\", \"generated_content\": \"...\"} 형태로 해줘."
    )

    headers = {
        "Authorization": f"Bearer {UPSTAGE_API_TOKEN}",
        "Content-Type": "application/json"
    }
    payload = {
        "model": "solar-pro",  # 또는 solar-mini 등 사용하려는 모델 이름
        "messages": [
            {
                "role": "user",
                "content": prompt_text
            }
        ]
    }
    response = requests.post(UPSTAGE_API_URL, json=payload, headers=headers)
    
    if response.status_code == 200:
        resp_data = response.json()
        # Upstage 응답에서 choices[0].message.content에 JSON 문자열이 담겨있다고 가정합니다.
        try:
            choice = resp_data.get("choices", [])[0]
            message = choice.get("message", {})
            content_str = message.get("content", "")
            # JSON 문자열로 응답된 내용을 파싱합니다.
            result = json.loads(content_str)
            generated_title = result.get("generated_title", "AI 제목 생성 실패")
            generated_content = result.get("generated_content", "AI 본문 생성 실패")
        except Exception as e:
            generated_title = "[ERROR] 파싱 실패"
            generated_content = f"응답 파싱 중 오류 발생: {str(e)}"
    else:
        generated_title = "[ERROR] AI 생성 실패"
        generated_content = f"Status Code: {response.status_code}, {response.text}"

    return jsonify({
        "generated_title": generated_title,
        "generated_content": generated_content
    })

if __name__ == "__main__":
    # 0.0.0.0:8000 포트로 Flask 실행
    app.run(host="0.0.0.0", port=8000)