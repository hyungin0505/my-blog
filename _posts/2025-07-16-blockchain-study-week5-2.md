---
title: "[Week 6] 블록체인"
description: CryptoZombies Lesson 6
date: 2025-07-16 19:57:00 +0900
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

## Chapter 1

```solidity
function test() external view onlyOwner anotherModifier { /* ... */ }
```

여러 개의 제어자를 함수 하나에 한꺼번에 사용할 수도 있다  
<br>

---

솔리디티에서 `payable` 함수는 이더를 받을 수 있는 함수이다  

이더, 데이터(Transaction Payload)와 컨트랙트 코드 자체는 이더리움 상에서 존재하기 때문에 함수 실행과 동시에 컨트랙트에 이더를 지불할 수 있다  
<br>

---

```solidity
uint levelUpFee = 0.001 ether;

function levelUp(uint _zombieId) external payable {
require(msg.value == levelUpFee);
zombies[_zombieId].level++;
}
```

`ehter`는 `seconds`처럼 이러리움에서 기본적으로 제공하는 이더 단위이다  
`msg.value`를 사용해서 컨트랙트로 이더가 얼마나 보내졌는지 확인할 수 있다  

`payable` 함수 제어자를 사용하지 않고 함수를 정의하고 이더를 보내려 한다면 함수에서 트랜잭션을 거부한다  
<br>

---

## Chapter 2

컨트랙트로부터 이더를 인출하는 함수를 만들지 않으면 컨트랙트로 이더를 보냈을 때 해당 컨트랙트의 이더리움 계좌에 이더가 저장되고 그 안에 갇힌다  
따라서, 컨트랙트에 이더를 보내는 함수가 있다면 가져오는 함수도 만들어야 한다  
<br>

---

```solidity
function withdraw() external onlyOwner {
    owner.transfer(this.balance);
}
```

`Ownable`을 import하고 `onlyOwner`를 사용하면 `transfer` 함수를 사용하여 이더를 특정 주소로 전달할 수 있다  
`this.balance`는 컨트랙트에 저장된 전체 잔액을 반환한다  

`owner` 대신 `msg.sender` 등을 사용하여 컨트랙트 소유자 뿐만 아니라 특정 누군가에게도 이더를 전송할 수 있다 (인출시킬 수 있다)  
<br>

---

## Chapter 3

```solidity
pragma solidity ^0.4.19;

import "./zombiehelper.sol";

contract ZombieBattle is ZombieHelper {

}
```
<br>

---

## Chapter 4

```solidity
import "./zombiehelper.sol";

contract ZombieBattle is ZombieHelper {
  uint randNonce = 0;

  function randMod(uint _modulus) internal returns(uint) {
    randNonce++;
    return uint(keccak256(now, msg.sender, randNonce)) % _modulus;
  }
}
```

`keccak256()` 해시 함수를 사용하여 난수 값을 생성할 수 있다  
<br>

> **신뢰할 수 없는 노드에서의 위험성**  
> 
> 이더리움에서 컨트랙트 함수를 실행하면 **트랜잭션**으로서 네트워크의 노도 하나 또는 여러 개의 노드에 실행을 알린다  
> 네트워크 상의 노드들은 여러 트랜잭션을 모으고 작업 증명(PoW) 이후 네트워크에 블록 형태로 배포한다  
> 
> 하나의 노드가 어떤 PoW를 풀면 다른 노드들은 해당 PoW 풀이를 멈추고 해당 노드의 트랜잭션 목록이 유효한지 검증한다  
> 유효하다면 해당 블록을 받아들이고 다음 블록을 풀기 시작한다  
> 
> 신뢰할 수 없는 노드에서 노드를 실행 중일 때 트랜잭션을 하나의 노드에만 알리고 공유하지 않을 수 있다  
> 이 경우 원하는 값만을 내뱉는 난수 함수만 다음 블록에 포함시키고 다른 값을 내뱉는 트랜잭션은 다음 블록에 포함시키지 않을 수 있다   
> 
> 하지만 블록체인 상에 있는 수많은 이더리움 노드들이 다음 블록을 풀기 위해 경쟁 중이기에 다음 블록을 바로 풀 확률은 매우 낮다  
> 많은 시간과 연산 자원을 필요로 하지만 취약할 수 있는 가능성이 있기 때문에 위험하다   
{: .prompt-warning}

<details markdown="1">
<summary>안전한 난수 생성법</summary>

이더리움 블록체인 외부의 난수 함수에 접근할 수 있도록 **오라클**을 사용할 수 있다  
<br>

---

블록해시, 타임스탬프, 사용자 지정 값 등은 조작이 가능하거나 공개되어 있다  
컨트랙트가 확인할 수 있는 정보는 사람도 확인이 가능하기 때문이다  

사용자의 선택이 결과에 영향을 미치게 되면 사용자가 불이익을 받을 수 있다  
<br>

---

1. 각 사용자는 256비트의 해시값을 생성한다  
    - 해시값 N에 생성한다  
    - `sha3(N, msg.sender)` 등으로 로컬에서 커밋을 생성한다  
2. 컨트랙트에 커밋을 제출한다  
    - 보증금과 함께 전송한다  
3. 제출이 끝나면 공개한다
    - 각 사용자는 N을 공개한다  
    - 컨트랙트가 `hash(N, msg.sender)`로 커밋을 확인한다
4. 난수 결정
    - 모든 사용자의 N을 XOR하여 최종 랜덤값을 생성한다  

<br>

---

**고려할 점**  
- N은 반드시 추측 불가능하고 엔트로피가 높은 랜덤값이어야 한다  
- `hash`에 `msg.sender`를 포함하여 해시 중복 공격을 방지할 수 있다  
- 공개할지 말지 선택 가능한 것을 보증금으로 억제하여 마지막 공개자에게 유리하다  
- 마지막 공개자의 더블 찬스 문제는 남아있다  
- 사용자 간 협공을 막기 위해 보증금 + 인센티브 구조가 중요하다  
- 완전히 탈중앙화는 복잡하지만 가능하고, 대체로 신뢰 기반 구조와 혼합된다  
</details>
<br>

---

## Chapter 5

```solidity
import "./zombiehelper.sol";

contract ZombieBattle is ZombieHelper {
  uint randNonce = 0;
  uint attackVictoryProbability = 70;

  function randMod(uint _modulus) internal returns(uint) {
    randNonce++;
    return uint(keccak256(now, msg.sender, randNonce)) % _modulus;
  }
  function attack(uint _zombieId, uint _targetId) external {
    
  }
}
```
<br>

---

## Chapter 6

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

  KittyInterface kittyContract;

  modifier ownerOf(uint _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    _;
  }

  function setKittyContractAddress(address _address) external onlyOwner {
    kittyContract = KittyInterface(_address);
  }

  function _triggerCooldown(Zombie storage _zombie) internal {
    _zombie.readyTime = uint32(now + cooldownTime);
  }

  function _isReady(Zombie storage _zombie) internal view returns (bool) {
      return (_zombie.readyTime <= now);
  }

  function feedAndMultiply(uint _zombieId, uint _targetDna, string _species) internal ownerOf(_zombieId) {
    Zombie storage myZombie = zombies[_zombieId];
    require(_isReady(myZombie));
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    if (keccak256(_species) == keccak256("kitty")) {
      newDna = newDna - newDna % 100 + 99;
    }
    _createZombie("NoName", newDna);
    _triggerCooldown(myZombie);
  }

  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }
}
```
<br>

---

## Chapter 7

```solidity
pragma solidity ^0.4.19;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

  uint levelUpFee = 0.001 ether;

  modifier aboveLevel(uint _level, uint _zombieId) {
    require(zombies[_zombieId].level >= _level);
    _;
  }

  function withdraw() external onlyOwner {
    owner.transfer(this.balance);
  }

  function setLevelUpFee(uint _fee) external onlyOwner {
    levelUpFee = _fee;
  }

  function changeName(uint _zombieId, string _newName) external aboveLevel(2, _zombieId) ownerOf(_zombieId) {
    zombies[_zombieId].name = _newName;
  }

  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) ownerOf(_zombieId) {
    zombies[_zombieId].dna = _newDna;
  }

  function getZombiesByOwner(address _owner) external view returns(uint[]) {
    uint[] memory result = new uint[](ownerZombieCount[_owner]);
    uint counter = 0;
    for (uint i = 0; i < zombies.length; i++) {
      if (zombieToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }

}
```
<br>

---

## Chapter 8

```solidity
import "./zombiehelper.sol";

contract ZombieBattle is ZombieHelper {
  uint randNonce = 0;
  uint attackVictoryProbability = 70;

  function randMod(uint _modulus) internal returns(uint) {
    randNonce++;
    return uint(keccak256(now, msg.sender, randNonce)) % _modulus;
  }

  function attack(uint _zombieId, uint _targetId) external ownerOf(_zombieId) {
    Zombie storage myZombie = zombies[_zombieId];
    Zombie storage enemyZombie = zombies[_targetId];

    uint rand = randMod(100);
  }
}
```
<br>

---

## Chapter 9

```solidity
pragma solidity ^0.4.19;

import "./ownable.sol";

contract ZombieFactory is Ownable {

    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1 days;

    struct Zombie {
      string name;
      uint dna;
      uint32 level;
      uint32 readyTime;
      uint16 winCount;
      uint16 lossCount;
    }

    Zombie[] public zombies;

    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    function _createZombie(string _name, uint _dna) internal {
        uint id = zombies.push(Zombie(_name, _dna, 1, uint32(now + cooldownTime), 0, 0)) - 1;
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }

    function createRandomZombie(string _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        randDna = randDna - randDna % 100;
        _createZombie(_name, randDna);
    }

}
```
<br>

---

## Chapter 10

```solidity
import "./zombiehelper.sol";

contract ZombieBattle is ZombieHelper {
  uint randNonce = 0;
  uint attackVictoryProbability = 70;

  function randMod(uint _modulus) internal returns(uint) {
    randNonce++;
    return uint(keccak256(now, msg.sender, randNonce)) % _modulus;
  }

  function attack(uint _zombieId, uint _targetId) external ownerOf(_zombieId) {
    Zombie storage myZombie = zombies[_zombieId];
    Zombie storage enemyZombie = zombies[_targetId];
    uint rand = randMod(100);
    
    if (rand <= attackVictoryProbability) {
      myZombie.winCount++;
      myZombie.level++;
      enemyZombie.lossCount++;

      feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
    }
  }
}
```
<br>

---

## Chapter 11

```solidity
import "./zombiehelper.sol";

contract ZombieBattle is ZombieHelper {
  uint randNonce = 0;
  uint attackVictoryProbability = 70;

  function randMod(uint _modulus) internal returns(uint) {
    randNonce++;
    return uint(keccak256(now, msg.sender, randNonce)) % _modulus;
  }

  function attack(uint _zombieId, uint _targetId) external ownerOf(_zombieId) {
    Zombie storage myZombie = zombies[_zombieId];
    Zombie storage enemyZombie = zombies[_targetId];
    uint rand = randMod(100);
    if (rand <= attackVictoryProbability) {
      myZombie.winCount++;
      myZombie.level++;
      enemyZombie.lossCount++;
      feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
    } 
    else {
      myZombie.lossCount++;
      enemyZombie.winCount++;
    }
    _triggerCooldown(myZombie);
  }
}
```

솔리디티에서 자바스크립트처럼 `else` 문을 활용할 수 있다  
<br>

---

## Chapter 12

[내 좀비](https://share.cryptozombies.io/ko/lesson/4/share/%EA%B3%A0%EA%B0%84%EB%94%94?id=WyJjenw2NTUyMTYiLDEsMTRd)