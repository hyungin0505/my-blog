---
title: "Windows10 카카오톡 chat_data 채팅 내역 edb 파일 복호화"
description: Windows 10 카카오톡 채팅 내역 아티팩트 포렌식 및 edb 파일 복호화 알고리즘
date: 2025-02-17 23:36:00 +0900
categories: [Security, Forensic]
tags: [kakaotalk, artifact, edb]
author: hyungin0505
toc: true
comments: true
# image:
#     path: /assets/img/
#     alt: image alternative text
pin: false  
---

--- 

[DBpia](https://www.dbpia.co.kr/journal/articleDetail?nodeId=NODE11215974)  
[Reference](https://blog.system32.kr/304)

위 논문을 참고하였으며 해당 블로그에서 많은 도움을 받았다  
혹시라도 업데이트로 인해 달라진 점이 있지 않을까 걱정했지만 다행히도 암호화 방식은 유지되고 있었다  
그도 그럴 것이 만약 암호화 방식이 변경되면 기존 데이터 파일들이 복호화되지 않을 것이기에 유지할 수 밖에 없을 것이다  

포렌식이 좀 재밌어지길래 카카오톡 채팅 내역 복구를 해보기로 했다  
논문도 있고 블로그도 있길래 간단하게 학습 목적으로 진행해봤다  
<br>

---

![Image](https://blog.kakaocdn.net/dn/Vc9pO/btsMlF914nO/uabUkIRFNC89K7mX86DhzK/img.png)

카카오톡 친구 목록 및 채팅 내역 등이 저장된 데이터베이스 파일들은 `AppData/Local/Kakao/KakaoTalk/users`{: .filepath} 디렉토리에 저장된다  
<br>

---

![Image](https://blog.kakaocdn.net/dn/Da4u1/btsMlzaYrL3/6cjfjO3vw55qt1f8ZZscW0/img.png)

해시값 이름의 폴더 내에 주요 데이터들이 저장된다  
이 해시값에 대해서는 아래에서 언급하겠다  

이곳에 채팅 내역들이 저장되는데 `chat_data`{: .filepath} 폴더 안에 저장되어 있다  
<br>

---

![Image](https://blog.kakaocdn.net/dn/boSpqc/btsMlDEjIvG/jnN49SkCgF8Okgu9ttn7t0/img.png)

`chatLogs_` 로 시작하는 edb 파일들이 카카오톡 채팅 내역이 저장된 데이터베이스 파일들이다  
각 채팅방마다 하나씩 생성되는 것으로 보인다  

`cla`{: .filepath}, `cli`{: .filepath} 등 여러 폴더가 존재하지만 채팅 내역의 링크나 썸네일 같은 세밀한 부분들을 복원하는데 필요한 정보들이다

채팅 내역만 확인하기 위해서는 그다지 필요하지 않다  
<br>

---

![Image](https://blog.kakaocdn.net/dn/A4dqQ/btsMkyqqGvW/TxUzu1sG19sBNGqFAB2mQK/img.png)

헥스값을 보면 바로 알 수 있듯이 암호화가 되어 있는 것을 확인할 수 있다  
당연한 일이다..  
<br>

---

![Image](https://blog.kakaocdn.net/dn/cDhCbO/btsMl8cRiCQ/OODeIHJns56MceQejBKUC0/img.png){: .w-50 .left}
![Image](https://blog.kakaocdn.net/dn/bvJ3Tl/btsMlBNn6HD/WusPX3GFb4keFUKKoHMm61/img.png){: .w-50 .left}

복호화를 위해서는 `key`와 `iv`가 필요하다

`key`와 `iv`를 이용해서 4096바이트씩 끊어서 AES128 CBC모드로 복호화를 진행한다

4096 즉 16의 배수만큼 끊기기 때문에 패딩은 굳이 할 필요 없다  
<br>
<br>

---

`key`와 `iv`는 `pragma`와 `userId`를 이용해서 구할 수 있다

`userId` 같은 경우 논문에서도 소개되었듯 여러 가지 방법으로 구할 수 있다

본인은 단순히 채팅 내역을 복호화해보는 것이 목표였기 때문에 간단하게 메모리 덤프를 떠서 찾아냈다  

이 외의 방법을 간단하게 말하자면 `userId`를 1부터 하나씩 늘리면서 브루트 포싱하는 방법이 있다

다른 방법으로는 헤더 기반으로 브루트 포싱하는 방법이 있는데 우리는 암호화되지 않은 edb 파일의 헤더 16바이트를 알고 있다  
따라서 브루트 포싱할 대상의 범위가 줄어 시간이 단축될 수 있다

가장 빠른 방법은 아까 언급했던 해시값 이름의 폴더 이름을 토대로 `userId`를 유추하는 방법이다  
해당 폴더의 이름은 특정 암호화 방식으로 지어지는데 이에 대한 내용은 논문에서 확인할 수 있다  
<br>

---

![Image](https://blog.kakaocdn.net/dn/q3tjD/btsMlA116FL/SZMDghOphE58oi8R3Juaqk/img.png)

`pragma`를 얻어내기 위해서는 UUID와 하드디스크의 모델명/시리얼넘버를 이용해야 한다

cmd 명령어를 통해 찾을 수도 있지만 가장 간단하고 정확하게 가져오는 방법은 레지스트리에 카카오톡이 저장하는 값들을 읽어오는 것이다  

`HKEY\_CURRENT\_USER\SOFTWARE\Kakao\KakaoTalk\DeviceInfo`{: .filepath}  

더불어 카카오톡 실행 파일 내에 하드코딩되어 있는 key 값을 사용해야 하는데 이 값은 나의 실력 이슈인지 메모리 덤프로 찾아낼 수 없었다  
아무래도 가장 중요한 값이기에 외부적으로 노출이 되어있지는 않았는데 어찌저찌 해서 잘 찾으면 얻어낼 수 있다

논문에서도 언급되어있지 않아 스스로 직접 찾아야 한다  

이 key 값 없이도 복호화가 가능하다는 얘기가 있는데 난 아직 잘 모르겠다..  
(예전에 CTF에서 AES의 CBC모드 취약점을 활용하는 문제가 나왔었는데 비슷한 결일지도 모르겠다.. 난 암호학 잘 모르고 경험도 많이 없어서;;)  

솔직히 말하자면 찾는 방법을 정확하게 모른다 (그러니까 물어보지 마라..)  
그냥 삽질하다 보니까 우연히 키값 찾아서 그걸로 복호화해보니까 되길래 일단 그걸로 진행했다..  

`2025.04.13`{: .filepath} : **이 Key 값은 본인이 알아서 찾으시기를 바랍니다. 저에게 물어봐도 대답해드리지 않습니다.**  

중간에 포기할까 생각도 해봤지만 누군가가 했다면 나도 언젠가 할 수 있을 것이라는 생각으로 계속 하다가 찾아냈다 (좋은 경험)  
아무튼 더 연구해서 키값을 확실하게 알아내는 법을 알아내는게 좋을 것 같다  
<br>

---

이 모든 과정에서 가장 중요한 것은 어찌됐든 하드코딩된 `key` 값을 찾는 것인데 그것만 알아내면 모든 정보를 얻어낼 수 있다

모든 edb 파일이 같은 암호화 방식을 사용하는 것은 아니지만 `pragma`와 `key`를 사용하는 것은 똑같기에 복호화 방식만 달리 하면 된다  
<br>

---

![Image](https://blog.kakaocdn.net/dn/d8HSOw/btsMllqrn8W/XYhjHh5LaKpDpOS6bLPWgk/img.png)

얻어낸 `pragma`와 `key` 값을 이용해 `chatLog`{: .filepath} 파일을 복호화해서 헥스를 까보면 SQLite 헤더를 찾을 수 있다

복호화가 잘 되었다는 뜻이다  
<br>

---

![Image](https://blog.kakaocdn.net/dn/buY7GF/btsMkDFafkt/qrkaXRDgVqKNoLr0lkngO0/img.png)

SQLite 뷰어를 통해서 채팅 내역을 확인할 수 있다  
채팅 날짜와 시간도 함께 나온다  

아무 파일이나 복호화해봤던 건데 고등학교 선생님과의 1ㄷ1 대화가 복구되었다ㅋㅋ 오랜만..ㅜㅜ  
해보니까 19년도 채팅도 복구된다ㄷㄷ  

사진 파일 같은 경우 연결된 파일을 찾아서 복호화하면 확인할 수 있다  
일단 채팅 내역만 복호화해봤고 앞으로의 계획은 다른 파일들도 복호화해서 자동화하는 것이다  

채팅 내역 외에도 전송했던 사진, 동영상, 파일, 링크, 이모티콘 및 #샵검색 등 다양한 정보들을 복원할 수 있다  
복호화하는 코드를 각각 만들고 나면 자동화까지 해볼 생각이다  
<br>

---

하다가 든 생각인데 복호화 후 DB를 수정하고 다시 암호화해서 메타데이터까지 덮어쓰면 메세지 조작이 가능하지 않을까..  
