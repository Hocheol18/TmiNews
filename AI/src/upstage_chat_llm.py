from langchain.chat_models.base import BaseChatModel
from pydantic import Field
from langchain.schema import ChatResult, AIMessage, ChatGeneration, BaseMessage
from typing import List, Optional
import requests

class UpstageChatLLM(BaseChatModel):
    api_token: str = Field(...)
    model: str = "solar-pro"
    api_url: str = "https://api.upstage.ai/v1/chat/completions"

    def _generate(self, messages: List[BaseMessage], stop: Optional[List[str]] = None, **kwargs) -> ChatResult:
        headers = {
            "Authorization": f"Bearer {self.api_token}",
            "Content-Type": "application/json"
        }

        payload = {
            "model": self.model,
            "messages": [{"role": self._convert_role(msg), "content": msg.content} for msg in messages],
            "temperature": 0.7
        }

        response = requests.post(self.api_url, headers=headers, json=payload)
        if response.status_code != 200:
            raise Exception(f"Upstage API 오류: {response.status_code} - {response.text}")

        data = response.json()
        content = data["choices"][0]["message"]["content"]
        return ChatResult(generations=[ChatGeneration(message=AIMessage(content=content))])

    @property
    def _llm_type(self) -> str:
        return "upstage-chat"

    def _convert_role(self, msg: BaseMessage) -> str:
        if msg.type == "human":
            return "user"
        elif msg.type == "ai":
            return "assistant"
        elif msg.type == "system":
            return "system"
        elif msg.type == "tool":
            return "tool"
        else:
            raise ValueError(f"Unknown message type: {msg.type}")
