---
title: "[SSU CTF 2025] Writeup"
description: 2025 숭실대학교 해킹방어대회 Writeup
date: 2025-01-25 19:22:00 +0900
categories: [Security, CTF]
tags: [CTF, writeup]
author: hyungin0505
toc: true
comments: true
# image:
#     path: /assets/img/250125_0/1.png
#     alt: SSU CTF 2025
pin: false
---

---

![External Image](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FlJR9T%2FbtsL0M3BRLy%2FVfK00okUgnbNTK6s2PcI10%2Fimg.jpg){: .w-50 .right}

드림핵 시스템 해킹 로드맵 끝나면 CTF하려 했는데 숭실대 CTF 궁금해서 한번 참여해봤다   

반수하다가 드림핵 풀어보는데 예전에 공부했던 웹해킹도 많이 까먹었고 공백의 영향이 생각보다 컸다..   
아무래도 다시 한번 차근차근 공부를 해나가야겠다   
     
요번 CTF에서는 가장 쉬운 두 문제만 풀었다   
몇 개 풀만한 것들 더 있었는데 안 풀리길래 그냥 냅뒀다..   

이번 CTF로 느낀 건 Writeup을 꼼꼼히 보자   
분명 예전에 CTF에서 봤던 문제랑 비슷한데 Writeup을 제대로 안 봐서 기억이 안 났다..   
Writeup도 도움이 아주 많이 되는 것 같으니 CTF가 끝나면 꼼꼼히 읽어보며 공부해보는게 좋을 것 같다   
<br>
사이트 들어가자마자 눈에 들어오는 Cykor..   
시작부터 예비 2번의 눈물을 머금고 들어갔다ㅋㅋ   
열심히 공부하고 대학이 아쉽지 않아지도록 실력을 올려서 돌아가야겠다 마음 먹는 순간이었다   

참고로, 이 Writeup은 개인 기록용이니 보다 더 자세한 설명을 듣고 싶다면 다른 글을 찾아가십쇼   
전 엄청 쉬운 기본 문제만 풀었고 배경 지식도 없슴다..     
<br>

---

## meme

Takeover owner..

[https://sepolia.etherscan.io/address/0xc48bdba1481c391cf67249818d2e972f737976d8#code](https://sepolia.etherscan.io/address/0xc48bdba1481c391cf67249818d2e972f737976d8#code)  
<br>

---

![External Image](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FcjpdeC%2FbtsL2lJUsHP%2F66sEGaQjFgncdCdlGozIoK%2Fimg.png)

뭔지 잘 모르지만 링크를 들어가니 EtherScan이란 사이트로 연결됐다   
이름을 보아하니 이더리움 같은데 블록체인 관련 문제인가 추측해봤다  
<br>

---

```javascript
/**
 *Submitted for verification at Etherscan.io on 2025-01-19
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Ssumeme {
    address public owner;
    string private flag;

    constructor() {
        owner = msg.sender;

        uint256 blockHashPart = uint256(blockhash(block.number - 1)) % 1000000000;
        flag = string(abi.encodePacked("ssu{", uint2str(blockHashPart), "_m3m3}"));
    }

    function getFlag() public view returns (string memory) {
        require(msg.sender == owner, "Only the contract owner can access the flag. Contact to soongsil.asc@gmail.com :)");
        return flag;
    }

    function uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 length;
        while (j != 0) {
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint256 k = length;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
}
```

사실 `uint2sr` 함수를 제대로 분석해보지 않았다   
그냥 48 더하는 거 보고 대충 숫자를 문자로 바꾼다고 가정하고 풀었다   
근데 진짜 그냥 숫자를 문자로 바꾸는 함수였다..

그러면 플래그를 구하기 위해서 `uint2str(blockHashPart)`만 구하면 된다  
<br>

---

```java
constructor() {
        owner = msg.sender;

        uint256 blockHashPart = uint256(blockhash(block.number - 1)) % 1000000000;
        flag = string(abi.encodePacked("ssu{", uint2str(blockHashPart), "_m3m3}"));
    }
```

`block.number`에서 1을 빼고 `blockhash` 씌우면 되니까 `block.number`와 해쉬를 찾아보자  
<br>

---

![External Image](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbhHO0D%2FbtsL1DdxM8l%2FUCyGNZyzL9ziK1kcGqVWW1%2Fimg.png)

뭔 말인지 잘 모르지만 문제 설명에서도 `owner`를 찾으라 하니까 일단 `creator`를 찾아서 주소를 찾아갔다  
<br>

---

![External Image](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbJHq35%2FbtsL1DkhP5i%2FDalPYj6tG8aVCCqofeXie1%2Fimg.png)

블럭 세 개 있는데 아무래도 `Ssumeme`이 보이니 알맞게 잘 찾아온 것 같다   
그럼 `block.number`는 `7523642`로 유추해볼 수 있겠다  
<br>

---

![External Image](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2Fb35yNc%2FbtsL1rxC6ym%2FUShtQufTCBA5SD9sqiEkd1%2Fimg.png)

`block.number`에서 1을 뺀 값인 `7523641` 블럭으로 왔다  
<br>

---

![External Image](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FcU2j6f%2FbtsL1FWFeFd%2FJKE3mRGeVQ2AiTPbXV5950%2Fimg.png)

아래 More Details를 펼쳐보니까 해쉬가 나온다   
맞게 찾은 것인지는 모르겠으나 일단 밑져야 본전이라고 트라이해보기로 했다

해쉬 복사해서 1000000000로 나누면 `809209385`가 나온다   
이걸 문자열에 잘 섞으면 플래그가 나온다

솔직히 풀릴 줄 몰랐다   
뭐 제대로 알고 한 게 아니라 의식의 흐름대로 한 거라 당연히 안 될 줄 알고 플래그 입력했는데 Correct 뜨길래 놀랐다ㅋㅋ  
<br>

---

## compressor

I AM A MASTER OF COMPRESSION

nc ssuctf.kr 19995  
<br>

---

![External Image](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FQvHw8%2FbtsL1Fh9cJI%2FksZRKvu5WcxpAWKxu0ly61%2Fimg.png)

완전 언인텐으로 풀었다

그냥 raw data 입력했을 때 인코딩한 데이터와 `gzip` 적용한 데이터랑 일치하면 플래그 출력해주는 문제다

근데 엔터 쳐서 공백 주니까 풀렸다ㅋㅋ  
<br>

---

[gzip-quiine(Github)](https://github.com/Honno/gzip-quine/blob/main/quine.gz)

Recursive gzip으로 푸는 거라고 어떤 분이 디스코드로 알려주셨다

이렇게 두 가지 방식으로 인코딩된 값이 일치하는 문자열 찾는 문제가 CTF에서 종종 보이는데 Recursive라는 용어를 알게 됐다