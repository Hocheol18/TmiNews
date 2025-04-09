from flask import Flask, request, jsonify
import os
import json
import logging
from dotenv import load_dotenv
from upstage_chat_llm import UpstageChatLLM
from langchain.prompts import PromptTemplate
from langchain.chains import LLMChain

# 설정
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)
dotenv_path = os.path.join(os.path.dirname(__file__), "..", "..", ".env")
load_dotenv(dotenv_path)

app = Flask(__name__)
UPSTAGE_API_TOKEN = os.environ.get("UPSTAGE_API_TOKEN")

# Upstage LLM
llm = UpstageChatLLM(api_token=UPSTAGE_API_TOKEN, model="solar-pro")

# 카테고리별 프롬프트 템플릿
it_prompt = PromptTemplate(
    input_variables=["title", "content"],
    template="""
너는 IT 전문 기자야. 기술, 트렌드, 신제품 소식 등을 전문적인 문체로 써줘.

제목: {title}
내용: {content}

제목은 10단어 이상, 본문은 200단어 이상. JSON으로 응답:
{{"generated_title": "...", "generated_content": "..."}}
"""
)

entertainment_prompt = PromptTemplate(
    input_variables=["title", "content"],
    template="""
너는 디스패치 스타일의 연예 기자야. 독점 보도, 목격담, 연애설, 열애설, 논란 중심의 자극적이고 눈에 띄는 기사 문체로 작성해줘.

- 제목은 눈길을 끄는 헤드라인 스타일로 작성하고,
- 본문은 목격자 언급, 관계자의 말, 'A씨', 'B양' 같은 표현도 사용해도 돼.
- 가십 느낌을 살리되, 너무 자극적이거나 허위 사실은 피하고 자연스럽게 꾸며줘.

제목: {title}
내용: {content}

제목은 10단어 이상, 본문은 200단어 이상. 아래 형식으로 JSON 응답:
{{"generated_title": "...", "generated_content": "..."}}
"""
)


sports_prompt = PromptTemplate(
    input_variables=["title", "content"],
    template="""
너는 스포츠 전문 기자야. 경기 요약, 선수 평가, 통계 등을 중심으로 역동적인 문체로 써줘.

제목: {title}
내용: {content}

제목은 10단어 이상, 본문은 200단어 이상. JSON으로 응답:
{{"generated_title": "...", "generated_content": "..."}}
"""
)

society_prompt = PromptTemplate(
    input_variables=["title", "content"],
    template="""
너는 사회 전문 기자야. 사회적 이슈, 사건 사고를 객관적이고 중립적인 문체로 다뤄줘.

제목: {title}
내용: {content}

제목은 10단어 이상, 본문은 200단어 이상. JSON으로 응답:
{{"generated_title": "...", "generated_content": "..."}}
"""
)

health_prompt = PromptTemplate(
    input_variables=["title", "content"],
    template="""
너는 건강 전문 기자야. 의학 정보, 건강 팁, 생활 습관 관련 내용을 신뢰감 있게 써줘.

제목: {title}
내용: {content}

제목은 10단어 이상, 본문은 200단어 이상. JSON으로 응답:
{{"generated_title": "...", "generated_content": "..."}}
"""
)

finance_prompt = PromptTemplate(
    input_variables=["title", "content"],
    template="""
너는 재테크 전문 기자야. 투자, 절세, 금융 팁 등을 전문적인 용어와 분석으로 써줘.

제목: {title}
내용: {content}

제목은 10단어 이상, 본문은 200단어 이상. JSON으로 응답:
{{"generated_title": "...", "generated_content": "..."}}
"""
)

default_prompt = PromptTemplate(
    input_variables=["title", "content"],
    template="""
너는 뉴스 기사 작가야. 일반적인 문체로 제목과 본문을 작성해줘.

제목: {title}
내용: {content}

제목은 10단어 이상, 본문은 200단어 이상. JSON으로 응답:
{{"generated_title": "...", "generated_content": "..."}}
"""
)

# 카테고리 기반 프롬프트 선택 함수
def get_chain_by_category(category: str, llm):
    category = category.strip().lower()
    if category == "it":
        return LLMChain(llm=llm, prompt=it_prompt)
    elif category == "연예":
        return LLMChain(llm=llm, prompt=entertainment_prompt)
    elif category == "스포츠":
        return LLMChain(llm=llm, prompt=sports_prompt)
    elif category == "사회":
        return LLMChain(llm=llm, prompt=society_prompt)
    elif category == "건강":
        return LLMChain(llm=llm, prompt=health_prompt)
    elif category == "재테크":
        return LLMChain(llm=llm, prompt=finance_prompt)
    else:
        return LLMChain(llm=llm, prompt=default_prompt)

# 생성 API
@app.route("/generate", methods=["POST"])
def generate():
    try:
        data = request.get_json(force=True)
    except Exception as e:
        logger.error(f"JSON 파싱 에러: {e}")
        return jsonify({"error": "유효한 JSON 데이터를 전송해주세요."}), 400

    title = data.get("title", "").strip()
    content = data.get("content", "").strip()
    category = data.get("category", "").strip()
    
    if not title or not content or not category:
        return jsonify({"error": "title, content, category 값은 필수입니다."}), 400

    try:
        chain = get_chain_by_category(category, llm)
        output = chain.invoke({
            "title": title,
            "content": content
        })
        result = json.loads(output)
        generated_title = result.get("generated_title", "AI 제목 생성 실패")
        generated_content = result.get("generated_content", "AI 본문 생성 실패")
    except Exception as e:
        logger.error(f"AI 생성 실패 또는 파싱 오류: {e}")
        generated_title = "[ERROR] 처리 실패"
        generated_content = f"오류: {str(e)}"

    return jsonify({
        "generated_title": generated_title,
        "generated_content": generated_content
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
