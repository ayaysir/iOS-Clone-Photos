# iOS 사진앱 클론 (일부분)

## 사용 기술
- SwiftUI
- Swift Concurrency
- Photos: 앱을 사용하기 위해 라이브러리에 대한 전체 접근 허용 권한이 필요합니다.
- UIKit, Combine 일부 내용 포함

## 구현 기능
- 보관함 (Library) 탭
  - 사진 리스트
    - 사진 섬네일 표시: 섬네일 영역에 화면에 표시될 때 비동기적으로 로드
    - 컨텍스트 메뉴
      - 섬네일을 길게 누르면 강조된 컨텍스트 메뉴가 표시됩니다.
      - 복제: 사진을 복제하여 라이브러리에 추가합니다.
      - 삭제: 사진을 라이브러리에서 삭제합니다.
      - 앨범 추가: 앨범에 사진을 추가합니다.
  - 사진 상세 보기
    - 고화질 원본 이미지를 비동기적으로 로드
    - 왼쪽/오른쪽 스와이프시 이전/다음 사진으로 이동
    - 확대/축소/이동 기능
  - 앨범 추가
    - 기존의 앨범 리스트 표시
    - 새로운 앨범 생성 기능
    - 앨범 섬네일을 클릭하면 해당 앨범에 사진이 추가됩니다.

- 앨범 (Albums) 탭
  - 기존 앨범 리스트 표시
  - 앨범을 클릭하면 해당 앨범의 사진 목록이 표시됩니다.
  - 기타 구현하지 못한 부분도 레이아웃은 되어 있습니다.
 
## 스크린샷

![Simulator Screenshot - iPhone 15 Pro - 2024-08-13 at 19 02 38](https://github.com/user-attachments/assets/329aa7ad-da20-4d74-b917-102bf2358fd5)
![Simulator Screenshot - iPhone 15 Pro - 2024-08-13 at 19 02 45](https://github.com/user-attachments/assets/edc8d173-96a7-4a97-b06a-8b42423882e7)
![Simulator Screenshot - iPhone 15 Pro - 2024-08-13 at 19 04 13](https://github.com/user-attachments/assets/db14fd76-7ae5-41e4-b233-8c40c176d693)
![Simulator Screenshot - iPhone 15 Pro - 2024-08-13 at 19 04 32](https://github.com/user-attachments/assets/81fa6ba4-0ca7-4544-b5ed-c0db680c68f2)
![Simulator Screenshot - iPhone 15 Pro - 2024-08-13 at 19 04 38](https://github.com/user-attachments/assets/ba435975-ecf3-4e9f-8923-b7dd2354a575)
![Simulator Screenshot - iPhone 15 Pro - 2024-08-13 at 19 04 45](https://github.com/user-attachments/assets/aafa7db8-9440-4225-beef-14bd9abbf49b)
![Simulator Screenshot - iPhone 15 Pro - 2024-08-13 at 19 04 52](https://github.com/user-attachments/assets/dba3a0e8-2776-447e-b286-befca234a347)
