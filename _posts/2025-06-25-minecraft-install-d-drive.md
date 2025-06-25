---
title: "심볼릭 링크로 마인크래프트 파일 D 드라이브로 변경 (.minecraft 폴더)"
description: 심볼릭 링크로 .minecraft 폴더 경로를 D 드라이브로 변경
date: 2025-06-25 20:08:00 +0900
categories: [Minecraft]
tags: [minecraft, symbolic]
author: hyungin0505
toc: true
comments: true
# image:
#     path: /assets/img/
#     alt: image alternative text
pin: false
---

---

지금 쓰는 C 드라이브 용량도 128기가로 적은데 이것저것 하느라 거의 다 찬 상태였다.  
마인크래프트 맵 용량까지 커지니까 아예 터질라 하길래 클라우드에 백업해놓고 초기화했다  

기본으로 C에 깔리는 프로그램들을 D에 설치되도록 하는 방법을 찾다가 이 방법을 마크에도 써보니까 잘 되길래 ㄹㅇ굳이라 쓴다  

혹시 모르니까 일단 백업해두고 따라하길 추천..  
근데 제대로 따라했을 때 웬만하면 오류는 잘 안 날 거임뇨  

**참고로 이 방법은 마크 말고도 다른 프로그램들에도 똑같이 적용되니까 C 드라이브 용량을 아끼고 싶다면 똑같이 하면 된다**  

<br>

--- 

![Image](/assets/img/250625_0/0.png)
직접 `AppData\Roaming`{: .filepath}으로 가거나 윈도우키+R 로 실행 창을 띄운 뒤 `%appdata%`를 입력해서 이동한다  

여기에 `.minecraft`{: .filepath} 폴더가 있다는 건 어제 막 태어난 튀르크메니스탄 신생아도 잘 알고 있을 것이다  

<br>

--- 

![Image](/assets/img/250625_0/1.png)
`.minecraft`{: .filepath} 폴더를 옮길 곳을 D 드라이브에서 찾아 `.minecraft`{: .filepath} 폴더를 생성한다  

**기존 맵 파일이나 모드 등을 그대로 이어받아서 사용하고 싶다면 C드라이브에 있던 `.minecraft` 폴더를 그대로 끌고 오면 된다**  

잘 옮겨놨으면 기존 C 드라이브에 있던 `.minecraft`{: .filepath} 폴더는 삭제한다  

<br>

---

![Image](/assets/img/250625_0/2.png)
cmd (명령 프롬프트)를 관리자 권한으로 실행한다  

윈도우키 누르고 cmd 치면 나온다  

<br>

--- 

![Image](/assets/img/250625_0/3.png)
```powershell
mklink /d "C:\Users\{UserName}\AppData\Roaming\.minecraft" "D:\{Destination}"
```
**이걸 그대로 복사해서 사용하지 말고 `{UserName}`은 사용자마다 다르게 때문에 자신의 환경에 맞게 입력해주어야 한다**  
(파일 탐색기에서 C 드라이브의 `AppData`{: .filepath}에 들어가 상단 주소창을 클릭하면 파일 경로와 `{UserName}`을 확인할 수 있다)

`{Destination}`에는 아까 D 드라이브에 두었던 `.minecraft`{: .filepath} 폴더 경로를 집어넣는다  

<br>

---

심볼릭 링크를 생성하는 건데 바로가기 느낌이라 생각하면 된다  
위 명령어가 제대로 실행되면 컴퓨터에서 기존 `.minecraft`{: .filepath} 폴더가 있던 위치에 `.minecraft`{: .filepath} 폴더가 생성되어 있을 텐데 아이콘이 좀 다를 것이다  

일반 폴더는 아니고 심볼릭 링크 폴더인데 들어가면 설정해두었던 D 드라이브로 바로 연결된다  
컴퓨터 시스템 입장에서도 `C:\Users\user\AppData\Roaming\.minecraft`{: .filepath}에 접근하면 `D:\AppData\Roaming\.minecraft`{: .filepath}로 연결되는 것이다  

잘 적용된 상태로 마인크래프트를 실행하면 잘 작동된다  

<br>

---

<details markdown="1">
<summary>기타 프로그램에 적용할 경우</summary>

"나는 그냥 C 드라이브에 윈도우만 깔고 나머지 모든 프로그램들은 D 드라이브에서 굴리고 싶은데 그냥 `AppData`{: .filepath} 폴더도 심볼릭 링크로 D 드라이브에 연결하면 되는 거 아님??"  

라고 생각할 수도 있다  
나도 그랬고..  

근데 검색해보니까 일부 프로그램들은 심볼릭 링크를 제대로 지원해주지 않아서 오류가 생길 수도 있고 Microsoft에서도 권장하지 않는 방법이라고 하니까 그냥 필요한 프로그램에만 조금씩 적용해주자  

일단 본인은 디스코드, 카카오톡, 마인크래프트, 오디오 드라이버, Mircrosoft Office 프로그램 등을 심볼릭 링크로 D 드라이브에 연결해놨는데 아직까지는 별 문제 없긴 하다..  

그래도 혹시 모르니 잘 봐가면서 설정해주자  

</details>