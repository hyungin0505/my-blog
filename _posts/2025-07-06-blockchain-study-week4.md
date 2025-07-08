---
title: "[Week 4] 블록체인"
description: CryptoZombies Lesson 2
date: 2025-07-06 12:55:00 +0900
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

# CryptoZombies Lesson 2

## Chapter 2

```solidity
mapping (uint => address) public zombieToOwner;
mapping (address => uint) ownerZombieCount;
```

이더리움 블록체인은 은행 계좌처럼 계정들로 이루어져 있다  
계정은 블록체인상의 통화인 **이더**를 가지기에 다른 계정과 이더를 주고 받을 수 있다  

은행 계좌 번호처럼 각 계정은 고유 식별자로 **주소**를 가진다  

**매핑**은 솔리디티에서 구조체와 배열처럼 구조화된 데이터를 저장하는 방법의 일종이다  
기본적으로 키-값(key-value) 저장소이며 데이터를 저장하고 검색하는 데 사용된다  

`mapping()`을 사용해 매핑을 정의할 수 있다  
위 예시의 첫번째 구문에서 키는 `uint`, 값은 `address`이다  

<br>

---

## Chapter 3

```solidity
mapping (uint => address) public zombieToOwner;
mapping (address => uint) ownerZombieCount;

function _createZombie(string _name, uint _dna) private {
    uint id = zombies.push(Zombie(_name, _dna)) - 1;
    zombieToOwner[id] = msg.sender;
    ownerZombieCount[msg.sender]++;
    NewZombie(id, _name, _dna);
}
```

솔리디티에는 모든 함수에서 사용 가능한 전역 변수들이 있다  
그 중에는 현재 함수를 호출한 사람 (또는 스마트 컨트랙트)의 주소를 가리키는 `msg.sender`가 있다  

솔리디티에서는 함수를 항상 외부 호출자가 실행하기 때문에 컨트랙트는 누군가 컨트랙트의 함수를 호출할 때까지 블록체인에서 아무 동작도 하지 않는다  
때문에 `msg.sender`가 필요하다  

`msg.sender`를 사용하면 이더리움 블록체인의 보안성을 이용할 수 있게 된다  
왜냐하면 누군가 다른 사람의 데이터를 변경하기 위해서는 해당 이더리움 주소와 관련된 개인키를 탈취해야 하기 때문이다  

<br>

---

## Chapter 4

```solidity
function createRandomZombie(string _name) public {
    require(ownerZombieCount[msg.sender] == 0);
    uint randDna = _generateRandomDna(_name);
    _createZombie(_name, randDna);
}
```

`require`를 사용하면 특정 조건이 참이 아닐 때 함수가 에러를 발생시키고 실행을 멈춘다  

```solidity
require(keccak256(_name) == keccak256("Vitalik"));
```
위 예시 코드는 `_name`이 **Vitalik**가 일치하지 않으면 에러를 반환한다  
(솔리디티에는 문자열을 그대로 비교하는 기능이 없기 때문에 해시 변환 후 비교한다)  

<br>

---

## Chatper 5

```solidity
pragma solidity ^0.4.19;

contract ZombieFactory {

    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }

    function createRandomZombie(string _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}

contract ZombieFeeding is ZombieFactory {
    
}
```

솔리디티에도 **상속** 기능이 있다  
A 컨트랙트가 B 컨트랙트를 상속 받으면 A 컨트랙트에서 B 컨트랙트의 모든 public 함수에 접근 가능하다  

<br>

---

## Chapter 6

```solidity
pragma solidity ^0.4.19;

import "./zombiefactory.sol";

contract ZombieFeeding is ZombieFactory {

}
```

솔리디티도 파이선처럼 `import`를 사용해서 코드를 여러 파일로 나누고 하나의 프로젝트로 만들 수 있다  

<br>

---

## Chapter 7

```solidity
contract ZombieFeeding is ZombieFactory {

  function feedAndMultiply(uint _zombieId, uint _targetDna) public {
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];
  }

}
```

솔리디티는 난수를 저장하기 위한 공간으로 **Storage**와 **Memory**가 있다  
**Storage**는 블록체인 상에 영구적으로 저장되는 변수이고, **Memory**는 컴퓨터 하드 디스크 RAM처럼 임시적으로 저장되는 변수이다  
Memory에 저장된 변수는 컨트랙트 함수에 대한 외부 호출이 일어나는 시점에 지워진다  

함수 외부에 선언되는 상태 변수는 `storage`로 선언되어 블록체인에 영구적으로 저장되고, 함수 내부에서 선언되는 변수는 `memory`로 선언되어 함수 호출이 종료되면 사라진다  

이렇게 솔리디티가 자체적으로 처리해주기 때문에 일반적으로 Storage와 Memory를 직접 사용할 필요는 없다  
하지만 함수 내의 구조체와 배열을 처리할 때는 사용할 필요가 있다  

<br>

---

## Chapter 8

```solidity
contract ZombieFeeding is ZombieFactory {

  function feedAndMultiply(uint _zombieId, uint _targetDna) public {
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];
    
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    _createZombie("NoName", newDna);

  }

}
```

<br>

---

## Chapter 9

```solidity
```

솔리디티는 `public`, `private` 말고도 `internal`과 `external`이라는 함수 접근 제어자가 존재한다  
`internal`은 `private`과 비슷하지만 정의된 컨트랙트를 상속하는 컨트랙트에서도 접근이 가능하다  
`external`은 `public`과 비슷하지만 컨트랙트 바깥에서만 호출될 수 있고 컨트랙트 내의 다른 함수들에 의해서는 호출될 수 없다  
선언하는 방법은 `public`과 `private` 함수를 선언하는 구문과 동일하다  

<br>

---

## Chapter 10

```solidity
contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

contract ZombieFeeding is ZombieFactory {

  function feedAndMultiply(uint _zombieId, uint _targetDna) public {
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    _createZombie("NoName", newDna);
  }

}

```

블록체인 상에 있으면서 내 컨트랙트가 내가 소유하지 않은 컨트랙트와 상호작용을 할 수 있다  
이를 위해서는 **인터페이스**를 정의해야 한다  

인터페이스에서는 함수만 선언하고 정의하지는 않는다  
컨트랙트의 뼈대로 생각할 수 있다  

<br>

---

## Chapter 11

```solidity
contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

contract ZombieFeeding is ZombieFactory {

  address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
  
  KittyInterface kittyContract = KittyInterface(ckAddress);

}

```

인터페이스를 사용해서 다른 컨트랙트와 상호작용하기 위해서는 상호작용하는 함수가 `public`이나 `external`로 선언되어야 한다  

<br>

---

## Chapter 12

```solidity
function multipleReturns() internal returns(uint a, uint b, uint c) {
  return (1, 2, 3);
}

function processMultipleReturns() external {
  uint a;
  uint b;
  uint c;
  (a, b, c) = multipleReturns();
}

function getLastReturnValue() external {
  uint c;
  (,,c) = multipleReturns();
}
```

위처럼 여러 개의 값을 반환하는 함수의 반환값을 받을 수 있다  
특정 반환값만 받고 싶을 경우 나머지 필드는 빈칸으로 두면 특정 반환값만 받을 수 있다  

```solidity
pragma solidity ^0.4.19;

import "./zombiefactory.sol";

contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

contract ZombieFeeding is ZombieFactory {

  address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
  KittyInterface kittyContract = KittyInterface(ckAddress);

  function feedAndMultiply(uint _zombieId, uint _targetDna) public {
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    _createZombie("NoName", newDna);
  }

  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_zombieId, kittyDna);
  } 

}
```

<br>

---

## Chapter 13

```solidity
contract ZombieFeeding is ZombieFactory {

  address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
  KittyInterface kittyContract = KittyInterface(ckAddress);

  function feedAndMultiply(uint _zombieId, uint _targetDna, string _species) public {
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];
    _targetDna = _targetDna % dnaModulus;
    
    uint newDna = (myZombie.dna + _targetDna) / 2;
    
    if (keccak256(_species) == keccak256("kitty")) {
      newDna = newDna - newDna % 100 + 99;
    }

    _createZombie("NoName", newDna);
  }

  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }

}
```

솔리디티는 자바스크립트처럼 if 조건문을 사용할 수 있다  

<br>

---
