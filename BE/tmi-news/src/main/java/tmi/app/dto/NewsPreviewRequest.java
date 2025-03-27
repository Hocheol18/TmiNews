package tmi.app.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class NewsPreviewRequest {
  private String title;
  private String content;
  private String category;
  private String newsTime; // "2018-03-28" or null
}
