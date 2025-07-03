---
title: "[Week 3] 블록체인"
description: 스마트 컨트랙트, Solidty (CryptoZombies), 개발 환경 설정 및 사용법
date: 2025-07-03 18:29:00 +0900
categories: [Security, BlockChain]
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

## 스마트 컨트랙트

### 개념

- 블록체인 기술을 기반으로 계약 조건을 코드로 작성하여 특정 조건이 충족되면 계약 내용이 자동으로 이행되도록 하는 시스템
- 중앙 기관의 개입 없이도 계약 당사자 간의 신뢰를 확보하고 계약 이행을 자동화한다

### 주요 특징 및 장점

- **자동화**: 계약 조건이 충족되면 자동으로 이행되기 때문에 수동적인 절차나 중개자의 개입이 불필요하다
- **투명성**: 계약 조건과 이행 과정이 블록체인에 기록되어 투명하게 공개된다
- **신뢰성**: 블록체인 기반으로 운영되기에 위변조가 어렵고 신뢰할 수 있는 계약 이행을 보장한다
- **비용 절감**: 중개자 수수료를 절감하고 계약 이행에 필요한 시간과 비용을 줄일 수 있다
- **효율성**: 자동화된 계약 처리를 통해 업무 효율성을 높일 수 있다
- **보안**: 블록체인 기술을 활용하여 보안을 강화할 수 있다

### 한계
- **법적 문제**: 아직 법적 효력이 명확하지 않아 계약 내용에 대한 법적 분쟁 발생 시 어려움이 있을 수 있다
- **유연성 부족**: 현실 계약의 복잡한 상황을 모두 반영하기 어려워 예상치 못한 상황에 대한 대처가 어려울 수 있다
- **기술적 한계**: 개발자의 실수나 해킹 등으로 예상치 못한 오류가 발생할 수 있다
- **데이터 연동**: 현실 세계의 데이터를 스마트 컨트랙트에 연동하는 과정에서 여러 문제가 발생할 수 있다

### 활용 사례
다양한 분야에서 활용될 수 있다  
- **금융**: DeFi에서 대출, 자산 관리, 거래 등 다양한 금융 계약에 활용된다
- **부동산**: 토지 등기, 임대차 계약 등 부동산 관련 계약을 자동화하고 투명하게 관리한다
- **보험**: 보험금 청구, 지급 등 보험 관련 계약을 자동화하고 효율적으로 처리할 수 있다
- **물류**: 상품 추적, 운송 계약, 관세 처리 등 국제 물류 시스템에서 활용 가능하다

<br>

---

## Solidity with CryptoZombies

### Chapter 2

```solidity
pragma solidity ^0.4.19;

contract ZombieFactory {

} 
```
솔리디티 코드는 **컨트랙트**안에 싸여 있다  
컨트랙트는 이더리움 애플리케이션의 기본 구성 요소이다   

모든 솔리디티 소스 코드는 **version pragma**로 시작하는데 솔리디티의 버전을 선언하는 것이다  
새로운 프로젝트의 초기 뼈대는 위 코드 블럭과 같다  
<br>

### Chapter 3

```solidity
pragma solidity ^0.4.19;

contract ZombieFactory {

    uint dnaDigits = 16;

}
```
**상태 변수**는 컨트랙트 저장소에 영구적으로 저장되는 변수이다  
블록체인이 기록된다는 의미이다  

`uint`는 부호 없는 정수 자료형이다 (unsigned int)  
부호 있는 정수 자료형을 사용하려면 `int`를 사용한다  
`uint`는 256비트 부호 없는 정수(`uint256`)를 표현하는데 `uint8`, `uint16`, `uint32` 등 더 작은 비트로 선언할 수도 있다  
<br>

### Chapter 4

```solidity
pragma solidity ^0.4.19;

contract ZombieFactory {

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

}
```

기본적인 사칙 연산이 가능하며 **지수 연산**도 가능하다  
<br>

### Chatper 5

```solidity
pragma solidity ^0.4.19;

contract ZombieFactory {

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

}
```

임의의 길이를 가진 문자열 자료형은 `string`을 사용한다   
UTF-8 데이터 문자열을 저장할 때 활용할 수 있다  

`struct` 자료형을 이용해 구조체를 사용하여 여러 특성을 가지고 더 복잡한 자료형을 생성할 수 있다  
<br>

### Chapter 6

```solidity
pragma solidity ^0.4.19;

contract ZombieFactory {

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

}
```

**배열**에는 **정적 배열**과 **동적 배열** 두 가지가 있다  

원소의 개수가 정해져 있는 고정 길이를 갖는 배열을 **정적 배열**이라 하고, 크기가 계속 커질 수 있어 고정 길이가 없는 배열을 **동적 배열**이라 한다  

특정 자료형 뒤에 [ ]을 붙여 해당 자료형 배열을 저장할 수 있다  
[ ] 안에 원소의 개수를 넣어 정적 배열을 사용한다  
(동적 배열의 경우 비워둔다)  

구조체 배열을 사용할 경우에는 자료형 대신 구조체 변수 이름을 사용한다  

`public`을 사용하게 되면 `getter` 메소드가 자동으로 생성된다  
따라서 다른 컨트랙트들이 이 배열을 가져와 읽을 수 있다  
(`setter` 메소드는 생성되지 않아 배열 수정은 불가능)  
<br>

### Chapter 7

```solidity
pragma solidity ^0.4.19;

contract ZombieFactory {

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    function createZombie(string _name, uint _dna) {

    }

}
```

`function`으로 함수를 선언할 수 있고 인자를 포함할 수 있다  
함수는 기본적으로 `public`으로 선언된다  

인자 이름은 언더바(_)로 시작해서 전역 변수와 구별할 수 있도록 하는 것이 관례다  
<br>

### Chapter 8

```solidity
pragma solidity ^0.4.19;

contract ZombieFactory {

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    function createZombie(string _name, uint _dna) {
        zombies.push(Zombie(_name, _dna));
    }

}
```

`.push()`를 사용하여 배열의 끝에 원소를 직접 추가할 수 있다  

`.push()`는 배열의 새로운 길이를 `uint` 형으로 반환한다  
<br>

### Chapter 9

```solidity
pragma solidity ^0.4.19;

contract ZombieFactory {

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    function _createZombie(string _name, uint _dna) private {
        zombies.push(Zombie(_name, _dna));
    }

}
```

함수는 기본적으로 `public`으로 선언되기 때문에 다른 컨트랙트가 해당 함수를 호출해 코드를 실행할 수 있다  
`private`으로 선언하면 컨트랙트 내의 함수들만 해당 함수를 호출할 수 있다  

최소 권환 원칙에 따라서 기본적으로 함수는 `private`으로 선언하고 공개해야할 필요가 있는 함수만 `public`으로 선언하는 것이 좋다  

`private` 키워드는 함수명 다음에 적으며 함수명을 언더바(_)로 시작하는 것이 관례다  
<br>

### Chapter 10

```solidity
pragma solidity ^0.4.19;

contract ZombieFactory {

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    function _createZombie(string _name, uint _dna) private {
        zombies.push(Zombie(_name, _dna));
    }

    function _generateRandomDna(string _str) private view returns (uint) {

    }

}
```

함수에서 어떠한 값을 반환받기 위해서는 `return`을 사용한다  
함수 선언과 동시에 반환값의 자료형도 명시해주어야 한다  

어떤 값을 변경하거나 쓰지 않고 읽기만 하는 함수는 `view`로 선언하고, 어떠한 데이터에도 접근하지 않는 함수는 `pure`로 선언한다  
이것들 **함수 제어자**라고 한다  
<br>

### Chapter 11

```solidity
pragma solidity ^0.4.19;

contract ZombieFactory {

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    function _createZombie(string _name, uint _dna) private {
        zombies.push(Zombie(_name, _dna));
    } 

    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));

        return rand % dnaModulus;
    }

}
```

이더리움은 SHA3의 한 버전인 `keccak256` 해시 함수가 내장되어 있다  
문자열을 랜덤한 256비트 16진수로 매핑하여 해시 값을 생성한다  

자료형이 다른 두 값을 이용해 연산할 때 형 변환을 할 필요가 있을 수 있다  
`uint8()`과 같은 함수를 사용해 명시적으로 형 변환을 할 수 있다  
<br>

### Chapter 12

```solidity
pragma solidity ^0.4.19;

contract ZombieFactory {

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    function _createZombie(string _name, uint _dna) private {
        zombies.push(Zombie(_name, _dna));
    } 

    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }

    function createRandomZombie(string _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}
```
<br>

### Chapter 13

```solidity
pragma solidity ^0.4.19;

contract ZombieFactory {

    // 여기에 이벤트 선언
    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    function _createZombie(string _name, uint _dna) private {
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        
        // 여기서 이벤트 실행
        NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }

    function createRandomZombie(string _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}
```

**이벤트**는 컨트랙트가 블록체인 상에서 앱의 클라이언트 단에서 액션이 발생했을 때 의사소통하는 방법이다  
컨트랙트는 특정 이벤트가 일어나는지 감지하고 그 이벤트가 발생하면 그에 맞는 동작을 수행한다  

`event`로 이벤트를 선언할 수 있다  
<br>

### Chapter 14

```javascript
// 여기에 우리가 만든 컨트랙트에 접근하는 방법을 제시한다:
var abi = /* abi generated by the compiler */
var ZombieFactoryContract = web3.eth.contract(abi)
var contractAddress = /* our contract address on Ethereum after deploying */
var ZombieFactory = ZombieFactoryContract.at(contractAddress)
// `ZombieFactory`는 우리 컨트랙트의 public 함수와 이벤트에 접근할 수 있다.

// 일종의 이벤트 리스너가 텍스트 입력값을 취한다:
$("#ourButton").click(function(e) {
  var name = $("#nameInput").val()
  // 우리 컨트랙트의 `createRandomZombie`함수를 호출한다:
  ZombieFactory.createRandomZombie(name)
})

// `NewZombie` 이벤트가 발생하면 사용자 인터페이스를 업데이트한다
var event = ZombieFactory.NewZombie(function(error, result) {
  if (error) return
  generateZombie(result.zombieId, result.name, result.dna)
})

// 좀비 DNA 값을 받아서 이미지를 업데이트한다
function generateZombie(id, name, dna) {
  let dnaStr = String(dna)
  // DNA 값이 16자리 수보다 작은 경우 앞 자리를 0으로 채운다
  while (dnaStr.length < 16)
    dnaStr = "0" + dnaStr

  let zombieDetails = {
    // 첫 2자리는 머리의 타입을 결정한다. 머리 타입에는 7가지가 있다. 그래서 모듈로(%) 7 연산을 하여
    // 0에서 6 중 하나의 값을 얻고 여기에 1을 더해서 1에서 7까지의 숫자를 만든다. 
    // 이를 기초로 "head1.png"에서 "head7.png" 중 하나의 이미지를 불러온다:
    headChoice: dnaStr.substring(0, 2) % 7 + 1,
    // 두번째 2자리는 눈 모양을 결정한다. 눈 모양에는 11가지가 있다:
    eyeChoice: dnaStr.substring(2, 4) % 11 + 1,
    // 셔츠 타입에는 6가지가 있다:
    shirtChoice: dnaStr.substring(4, 6) % 6 + 1,
    // 마지막 6자리는 색깔을 결정하며, 360도(degree)까지 지원하는 CSS의 "filter: hue-rotate"를 이용하여 아래와 같이 업데이트된다:
    skinColorChoice: parseInt(dnaStr.substring(6, 8) / 100 * 360),
    eyeColorChoice: parseInt(dnaStr.substring(8, 10) / 100 * 360),
    clothesColorChoice: parseInt(dnaStr.substring(10, 12) / 100 * 360),
    zombieName: name,
    zombieDescription: "A Level 1 CryptoZombie",
  }
  return zombieDetails
}
```

이더리움은 **Web3.js**라는 자바스크립트 라이브러리를 가진다  

<br>

---

[내 좀비](https://share.cryptozombies.io/ko/lesson/1/share/%EA%B3%A0%EA%B0%84%EB%94%94?id=Y3p8NjU1MjE2)

<br>

---

## Remix IDE
스마트 계약을 개발하기 위한 GUI 도구이다  
설치 없이 웹에서도 사용 가능하며 원하는 체인에 간단히 배포할 수 있는 과정을 제공한다  
온라인 IDE, 데스크탑 IDE, CLI 모두 지원한다  

### 플러그인
솔리디티 컴파일러, 파일 탐색기, 디버거 등등 다양한 핵심 플러그인이 존재하며 추가 플러그인으로 더 다양한 기능을 활용할 수 있다  

### IDE
네비게이션에 솔리디티 컴파일러 및 단위 테스터, 트랜잭션 배포 & 실행, Git 등이 있다  

몇 가지 프로젝트 템플릿이 제공되며 Web3 개발에 필요한 환경을 제공한다  