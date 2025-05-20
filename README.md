## **1. 프로젝트 개요** 


<div style="display: flex; gap: 50px; align-items: center; margin-bottom : 40px;">
  <img src="./docs/logo1.png" width="200" />
  <img src="./docs/logo2.png" width="200" />
  <img src="./docs/logo3.png" width="200" />
</div>


> TMI NEWS – AI 기반 뉴스 생성 & 큐레이션 서비스
> 
> 
> > 키워드만 입력하면, 나만을 위한 뉴스가 만들어진다!
> > 

**TMI NEWS**는 사용자가 원하는 주제의 뉴스를 손쉽게 받아볼 수 있도록 돕는 AI 기반 뉴스 생성 및 큐레이션 서비스입니다. 사용자가 입력한 키워드를 바탕으로 AI가 기사 초안을 작성하고, 관리자는 이를 검토해 수정 및 승인할 수 있습니다. 또한 사용자 피드백을 기반으로 뉴스 콘텐츠를 개선하고, 개인화된 뉴스 큐레이션 경험을 제공합니다.

## **2. 주요 기능**

### 🧠 **AI 뉴스 생성**

- **뉴스 생성 방식**
    - 사용자가 먼저 **카테고리 6종 중 하나**를 선택 (예: `IT`, `사회`, `연예`, `재테크`, `건강`, `스포츠`)
    - 이후 **본문 내용**을 자유롭게 입력 (예: “요즘 아이폰 15 프로 발열 이슈에 대한 내용 작성해줘”)
    - 입력된 내용은 **AI가 분석 → 뉴스 형식으로 자동 변환**함



<div style="display: flex; gap: 20px; align-items: center; margin-bottom : 40px; margin-top: 40px;">
  <img src="./docs/news_create.png" width="200" />
  <img src="./docs/news_picture.png" width="200" />
  <img src="./docs/news_complete.png" width="200" />
</div>

- **생성 결과**
    - 사용자가 작성한 주제에 따라 AI가 제목 / 본문 의 구조로 뉴스 작성
    - 결과가 마음에 든다면 발행하기 버튼을 통해 최종 발행 후 뉴스 발행 완료

### 📚 **뉴스 피드 (카드 뉴스형 UI)**

- 뉴스는 **카드 형식으로 정렬되어 피드에 출력**됩니다.
- 피드는 `카테고리 탭`(IT, 사회, 연예, 재테크, 게임, 스포츠 등)을 기준으로 필터링 가능하며, 기본 정렬은 **최신순**입니다.
- 각각의 뉴스 카드는:
    - 제목과 요약이 보여지며
    - 컬러 구분으로 카테고리를 직관적으로 인식할 수 있습니다.
- 사용자는 스크롤을 통해 다양한 주제의 뉴스를 **SNS처럼 빠르게 탐색**할 수 있습니다.



<div style="display: flex; gap: 20px; align-items: center; margin-bottom : 20px; margin-top: 40px;">
  <img src="./docs/news_all.png" width="200" />
  <img src="./docs/news_all2.png" width="200" />
  <img src="./docs/news_no.png" width="200 "/>
</div>
<div style="display: flex; gap: 20px; align-items: center; margin-bottom : 20px; margin-top: 20px;">
  <img src="./docs/news_detail4.png" width="200" />
  <img src="./docs/news_sports.png" width="200" />
  <img src="./docs/news_health.png" width="200" />
</div>

### ❤️ **좋아요 & 댓글**

- **좋아요 기능**
    - 뉴스 상세 페이지 하단에 위치한 ❤️ 버튼을 눌러 **좋아요를 표현**할 수 있어요.
    - 누른 좋아요 수는 실시간으로 반영되며, 인기 뉴스는 피드 상단에 더 잘 노출됩니다.
- **댓글 기능**
    - 사용자는 뉴스 하단에 바로 보이는 **입력창을 통해 댓글을 남길 수 있어요**.
    - 입력창에는 “댓글을 작성해보세요”라는 안내가 있으며, 작성 후 바로 아래 리스트에 반영됩니다.
    - 댓글에는 **작성자 닉네임과 작성 내용**이 함께 표시되어, 간단한 의견부터 감정 공유까지 자유롭게 표현할 수 있습니다.
    - 예시:
        - 김예지: “와 유용한 글이에요~”
        - 박호철: “좋은 기사 감사합니다ㅎㅎ”
        - 김홍탁: “앞으로도 좋은 콘텐츠 기대할게요!”
- **특징**
    - 인스타그램 스타일로 **입력 → 즉시 반영되는 반응형 구조**
    - 별도 새 창 없이 **본문과 댓글을 한 화면에서 몰입감 있게 확인 가능**

<div style="display: flex; align-items: center; margin-top: 20px;">
<img src="./docs/news_comment.png" width="200" />
</div>

### ☘️ **마이페이지**

- **글 모아보기 기능**
    - 지금까지 내가 쓴 기사들을 모아볼 수 있어요.
- **알림 기능**
    - 내가 쓴 글에 좋아요, 댓글이 달렸을 때 / 친구 신청, 완료의 경우에 알림이 와요
- **친구 기능**
  - 친구를 맺고 친구가 쓴 글을 모아서 확인할 수 있어요.

<div style="display: flex; gap: 20px; align-items: center; margin-top: 20px;">
<img src="./docs/profile1.png" width="200" />
<img src="./docs/profile2.png" width="200" />
</div>
<div style="display: flex; gap: 20px; align-items: center; margin-top: 20px;">
<img src="./docs/friend_list.png" width="200" />
<img src="./docs/friend_add.png" width="200" />
</div>

---

## **3. 사용 기술**

### FRONTEND
<div style="display : flex; gap: 10px; align-items: center;">
<img src="https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white">  
<img src="https://img.shields.io/badge/Riverpod-0175C2?style=flat&logo=flutter&logoColor=white">  
<img src="https://img.shields.io/badge/Dio-0175C2?style=flat&logo=flutter&logoColor=white">
</div>

### AI
<div style="display: flex; gap: 10px; align-items: center;">
<img src="https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white">  
<img src="https://img.shields.io/badge/Flask-000000?style=flat&logo=flask&logoColor=white">  
<img src="https://img.shields.io/badge/Upstage_AI-4E2A84?style=flat&logo=openai&logoColor=white">  
<img src="https://img.shields.io/badge/LangChain-FF9900?style=flat&logo=openai&logoColor=white">
</div>


### BACKEND

<div style="display: flex; gap: 10px;">
<img src="https://img.shields.io/badge/Spring-6DB33F?style=flat&logo=spring&logoColor=white">  
<img src="https://img.shields.io/badge/Spring_Boot-6DB33F?style=flat&logo=springboot&logoColor=white">  
<img src="https://img.shields.io/badge/MySQL-4479A1?style=flat&logo=mysql&logoColor=white">
</div>


### TOOLS

<div style="display:flex; gap : 10px;">
<img src="https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white">  
<img src="https://img.shields.io/badge/Postman-FF6C37?style=flat&logo=postman&logoColor=white">  
<img src="https://img.shields.io/badge/Notion-000000?style=flat&logo=notion&logoColor=white">  
<img src="https://img.shields.io/badge/GitHub-181717?style=flat&logo=github&logoColor=white">
</div>



## **4. 문서**

- [Figma (목업)](https://www.figma.com/design/b7wOUcVQ3qNW3CtGvSU0UG/Untitled?node-id=55-5&p=f&t=wTdJ3H2rx9C7oAsX-0)
- [API 명세](http://notion.so/API-1af627ac5de580199718fd43c3f80556)
