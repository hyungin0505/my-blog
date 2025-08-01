---
title: "[Ethernaut] 메타마스크 설정, Level 0 Writeup"
description: [Week6 블록체인]
date: 2025-08-01 10:05:00 +0900
categories: [Study, BlockChain]
tags: [blockchain]
author: hyungin0505
toc: true
comments: true
# image:
#     path: /assets/img/
#     alt: image alternative text
pin: false
---

---

## MetaMask 설치

[Ethernaut](https://ethernaut.openzeppelin.com/) 문제를 풀어보기 위해서는 MetaMask라는 브라우저 확장 프로그램을 사용해야 한다  
[메타마스크](https://chromewebstore.google.com/detail/metamask/nkbihfbeogaeaoehlefnkodbefgpgknn)에서 지갑을 생성하고 연결해야 한다  
<br>

---

![Image](/assets/img/250716_0/0.png)

웹스토어에서 [MetaMask](https://chromewebstore.google.com/detail/metamask/nkbihfbeogaeaoehlefnkodbefgpgknn)를 검색해서 설치한다  

설치 후 확장 앱을 열어 회원가입을 한다  
회원가입 시 발급되는 비밀번호 복구문은 잃어버리면 못 찾기 때문에 안전한 곳에 잘 보관해두어야 한다  
<br>

---

![Image](/assets/img/250716_0/1.png)

로그인을 하고 나면 네트워크에 연결해야 하는데 좌상단 버튼을 열면 선택 가능한 네트워크들이 나온다  

테스트 네트워크에 있는 Sepolia를 선택해서 연결해주면 된다  
(보이지 않을 경우 '테스트 네트워크 보기' 옵션을 켜면 된다)  
<br>

---

## 테스트 이더리움 받기

![Image](/assets/img/250716_0/7.png)

본인은 좀 해놔서 돈이 들어가있지만 처음 할 때는 0.00USD 무일푼이다ㅠㅠ
<br>

---

![Image](/assets/img/250716_0/5.png)

문제를 풀라믄 돈이 필요한데 다양한 곳에서 꽁돈을 받을 수 있다  
구글에 'ethereum sepolia faucet'을 검색하면 수두룩 뺵빽이 나온다  

본인은 [구글 클라우드](https://cloud.google.com/application/web3/faucet/ethereum/sepolia)에서 받았다  
Ethereum Sepolia 네트워크를 선택하고 내 지갑 주소를 올리면 된다  
내 지갑 주소는 메타마스크를 열면 창 상단에서 바로 복사할 수 있다  
<br>

---

![Image](/assets/img/250716_0/2.png)

돈을 잘 받으면 거래가 하나 완료된 것이기에 트랜잭션 해시를 받을 수 있다  
<br>

---

![Image](/assets/img/250716_0/4.png)

메타마스크에 들어가보면 돈이 들어와있는 걸 볼 수 있다  
<br>

---

## Etherscan에서 트랜잭션 확인

![Image](/assets/img/250716_0/3.png)

[Etherscan](https://sepolia.etherscan.io/tx/0xc9fdb93950b781672b090808e46b5a948365bcdbe4ed437685de9a2bf4268247)에서 한번 봅시다   

트랜잭션 해시, 블록 넘버, 타임스탬프, 수발신지, 수수료, 가스비 등의 정보가 나온다  

블록에 들어가서 해당 블록에 얼마나 많은 트랜잭션이 들어가 있는지, 이전 블록 해시, 난스 등을 확인할 수 있다  

From 주소로 들어가면 거래 내역들이 주루룩 나오는데 실시간으로 테스트 이더 발급받는 내역인 것 같다  
<br>

---

## Ethernaut Level 0

![Image](/assets/img/250716_0/9.png)

Ethernaut를 플레이하기 위해서는 메타마스크 지갑을 연동해야 한다  

Connect 버튼을 눌러 연동을 해준다  
<br>

---

![Image](/assets/img/250716_0/10.png)

이미 메타마스크에 로그인된 상태라면 자동으로 연동되어 Connect 버튼이 안 나올 수도 있다  

이때 개발자 도구 콘솔에서 `getBalance(player)` 또는 `player`를 입력했을 때 결과가 나온다면 자동으로 연동이 된 것이다  

`player`는 사용자의 메타마스크 지갑 주소를 반환하고 `getBalance()`는 특정 사용자가 얼마를 가지고 있는지 보여준다  

> `getBalance()` 등 명령어를 사용할 때 `await getBalance()`처럼 `await`를 사용하면 좀 더 깔끔한 응답을 받을 수 있다  
{: .prompt-info}
<br>

---

![Image](/assets/img/250716_0/12.png)

`help()`로 어떤 명령어들이 있는지 확인해볼 수 있다  
<br>

---

이 외 `await ethernaut.owver()` 등 명령어들도 있는데 궁금하면 직접 해보고 문제를 풀어보자  
<br>

---

![Image](/assets/img/250716_0/11.png)

Get new instance 버튼을 누르면 메타마스크에서 트랜잭션 요청 팝업이 나온다  

컨펌을 눌러 지불해주면 인스턴스가 열린다  
<br>

---

![Image](/assets/img/250716_0/13.png)

문제에서 하라는 대로 따라하면 된다  

`infoNum` 속성이 호출해야 할 다음 메소드를 갖고 있다고 한다  
사실 개발자 도구 콘솔에 내장된 명령어 자동완성으로 다음 메소드가 무엇인지 알 수 있지만 일단 한번 찾아보도록 하자  
<br>

---

![Image](/assets/img/250716_0/16.png)

`words`에 42가 있으니 다음 info 메소드 번호는 42인 것 같다  
<br>

---

![Image](/assets/img/250716_0/17.png)

비밀번호를 찾아 `authenticate()`에 넣으라고 한다  
<br>

---

![Image](/assets/img/250716_0/14.png)

`password()` 메소드로 비밀번호를 찾을 수 있다  
<br>

---

![Image](/assets/img/250716_0/15.png)

비밀번호를 `authenticate()`에 넣으면 메타마스크에 트랜잭션 요청이 뜬다  

컨펌 후 Submit instnace 버튼을 누르고 새로운 트랜젹샌 요청까지 컨펌해주면 Level 0이 풀린다  