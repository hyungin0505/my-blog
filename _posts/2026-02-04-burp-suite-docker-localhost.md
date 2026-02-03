---
title: "Burp Suite에서 도커 localhost 안 잡히는 문제 해결"
description: "작동 중인 도커 로컬호스트에 연결 안 되는 문제 해결 방법"
date: 2026-02-4 03:17:00 +0900
categories: [Others]
tags: [docker, burp suite]
author: hyungin0505
toc: true
comments: true
# image:
#     path: /assets/img/
#     alt: image alternative text
pin: false
---

---

역시 이럴 땐 지피티보다 검색이 최고다  

분명 도커에서 포트도 제대로 열었는데 버프 스위트 내장 브라우저로 잡으려 하니 localhost, 127.0.0.1 이것저것 다 해보아도 무한 로딩에 걸린다..  
일반 브라우저에서는 접속되는데 버프 스위트에서만 안 열린다  

이럴 땐 그냥 localhost 대신 \[::1\]로 접속하면 된다  
포트도 그냥 뒤에 붙여서 \[::1\]:8000 이렇게..  