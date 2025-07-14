---
title: "[Week 5] 블록체인"
description: CryptoZombies Lesson 5
date: 2025-07-14 22:32:00 +0900
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

이더리움에 컨트랙트를 배포하고 나면 해당 컨트랙트는 블록체인 상에 영구적으로 존재하게 된다  
절대 코드를 수정하거나 삭제할 수 없는데 이러한 특성을 **Immutable**이라고 한다  
<br>

---

```solidity
contract ZombieFeeding is ZombieFactory {

  address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
  KittyInterface kittyContract = KittyInterface(ckAddress);

}
```
```solidity
contract ZombieFeeding is ZombieFactory {

  KittyInterface kittyContract;

  function setKittyContractAddress(address _address) external {
    kittyContract = KittyInterface(_address);
  }
}
```

위 코드에서 `ckAddress`는 다른 DApp 컨트랙트의 주소에 해당한다  
해당 주소를 가진 컨트랙트의 코드에 문제가 생겨 주소를 변경해야 하는 경우를 대비하여 주소 같은 중요한 정보를 변경할 수 있도록 하기 위해 직접 정보를 수정하는 함수를 생성한다  
<br>

---

## Chapter 2

하지만 이전 Chapter 1처럼 주소를 변경하는 함수를 `external`로 생성하면 누구든 이 함수를 호출하여 주소를 수정할 수 있다  
이런 경우를 대비하기 위해 컨트랙트를 소유 가능하게 만들 수 있다  
<br>

---

```solidity
/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;
  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }
}
```

OpenZeppelin 솔리디티 라이브러리의 `Ownable` 컨트랙트의 코드이다  

`functoin Ownable()`은 **생성자(Constructor)**이다  
이 함수는 컨트랙트가 생성될 때 한 번만 실행된다  

`modifier onlyOwner()`는 **함수 제어자 (Function Modifier)**이다  
다른 함수들에 대한 접근을 제어하기 위해 사용되는 유사 함수로 보통 함수 실행 전 요구사항 충족 여부를 확인하는 데 사용된다  

`onlyOwner`는 접근을 제한하여 오직 컨트랙트의 소유자만 해당 함수를 실행할 수 있도록 하기 위해 사용될 수 있다  
<br>

---

`Ownable` 컨트랙트는 컨트랙트가 생성되면 컨트랙트의 생성자가 `owner`에 `msg.sender`를 대입한다  
여기서 `msg.sender`는 컨트랙트를 배포한 사람이다  

특정한 함수들에 소유자만 접근할 수 있도록 `onlyOwner` 접근 제어자를 추가한다  

새로운 소유자에게 해당 컨트랙트의 소유권을 옮길 수 있도록 할 수도 있다  
<br>

---

대부분의 솔리디티 DApp은 `Ownable` 컨트랙트를 복사/붙여넣기 하여 시작한다  
그리고 첫 컨트랙트에는 이 컨트랙트를 상속해서 만든다  
<br>

---

```solidity
pragma solidity ^0.4.19;

import "./ownable.sol";

contract ZombieFactory is Ownable {
...
}
```

`import`로 미리 복사해둔 Ownable 컨트랙트를 불러오고 `ZombieFactory`가 `Ownable`을 상속받도록 한다  
<br>

---

## Chapter 3

함수 제어자는 `function` 키워드가 아닌 `modifier` 키워드를 사용한다   
따라서, 함수를 실행할 때처럼 직접 호출할 수 없다   
<br>

---

```solidity
modifier onlyOwner() {
  require(msg.sender == owner);
  _;
}
```

`onlyOnwer()` 함수 제어자를 사용한다고 해보자  

```solidity
contract MyContract is Ownable {
  event LaughManiacally(string laughter);

  function likeABoss() external onlyOwner {
    LaughManiacally("Muahahahaha");
  }
}
```

`likeABoss()` 함수를 호출하면 `onlyOwner`의 코드가 먼저 실행된다  
`onlyOnwer`의 `_;` 부분에서는 `likeABoss` 함수로 되돌아가 해당 코드를 실행하게 된다  

함수 실행 전에 `require`를 사용하여 호출자가 소유자인지 확인한다  
<br>

> **백도어 함수**  
> 컨트랙트에 특별한 권한을 갖도록 하여 백도어 함수를 추가하는 등 악의적으로 활용될 수 있다  
> 때문에 반드시 전체 코드를 읽고 잠재적인 위협이 있는지 확인하고 검증한 후에 사용하는 것이 안전하다  
{: .prompt-danger}

<br>

---

## Chapter 4

솔리디티에서 만든 DApp의 함수를 실행하기 위해서는 **가스**라는 화폐를 지불해야 한다  
사용자는 ETH를 이용해서 가스를 사는데 DApp을 실행하기 위해 사용자들은 ETH를 소모한다  

함수의 복잡도에 따라 필요한 가스량이 달라지는데 각각의 연산에는 **가스 비용 (Gas Cost)**이 있고 그 연산을 수행하는 데 소모되는 컴퓨팅 자원의 양이 이 비용을 결정한다  
함수 전체의 가스 비용은 그 함수의 개별 연산들의 가스 비용의 합이다  

사용자가 소모하는 가스 비용을 줄이기 위해 코드를 최적화하는 것이 매우 중요하다  
<br>

> **가스가 필요한 이유**  
> 이더리움 상에서 어떤 함수를 실행할 때 네트워크 상의 모든 개별 노드가 함수의 출력값을 검증하기 위해 해당 함수를 실행한다  
> 그 수 천 개의 노드가 이더리움을 분산하고 데이터를 보존하면서 탈중앙화가 이루어질 수 있도록 한다  
> 
> 무한 반복문 등으로 네트워크를 방해하거나 자원 소모가 매우 큰 연산을 사용하여 네트워크 자원을 모두 사용하지 못하도록 하기 위해서 연산 처리에 비용이 들도록 개발하였다  
> 때문에 사용자들은 저장 공간 뿐만 아니라 연산 사용 시간에 따라서도 비용을 지불해야 한다  
{: .prompt-tip}
<br>

---

`uint256`에서 크기를 줄여 하위 타입인 `uint8`을 쓰는 것은 가스 소모를 줄이는 데에 아무런 영향이 없다  
하지만 `struct` 구조체 내부에서는 예외인데 최대한 작은 크기의 타입을 사용하는 것이 좋다  
저장 공간을 최소화할 수 있기 때문이다  

더불어, 동일한 데이터 타입은 하나로 묶어서 메모리 상에서 서로 옆에 있도록 선언하는 것이 좋다  
<br>

---

## Chapter 5

솔리디티는 시간을 다룰 수 있는 단위계를 기본적으로 제공한다  
`now` 변수를 사용해서 32비트 정수형인 UNIX 타임스탬프를 얻을 수 있다  
(자료형은 `uint256`으로 반환되기에 필요하다면 `uint32`로 명시적 변환을 해줄 필요가 있다)  

---

```solidity
uint cooldownTime = 1 days;
```

외에도 `seconds`, `minutes`, `hours`, `days`, `weeks`, `years` 같은 시간 단위 또한 제공된다  
그들에 해당하는 길이 만큼의 초 단위가 `uint`로 반환된다  
<br>

---

## Chapter 6

```solidity
function _triggerCooldown(Zombie storage _zombie) internal {
  _zombie.readyTime = uint32(now + cooldownTime);
}

function _isReady(Zombie storage _zombie) internal view returns(bool) {
  return (_zombie.readyTime <= now);
}
```

<br>

---

## Chapter 7

작성한 코드의 보안을 검증할 때에는 `public`과 `external` 함수를 검사하여 사용자들이 해당 함수를 남용할 가능성이 있을지 생각해보는 것잇 좋다  
이 함수들이 `onlyOwner`와 같은 함수 제어자를 갖지 않는 이상 어떤 사용자든 이 함수들을 호출하고 원하는 모든 데이터를 전달할 수 있다  
<br>

<details markdown="1">
<summary>코드</summary>

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

  function setKittyContractAddress(address _address) external onlyOwner {
    kittyContract = KittyInterface(_address);
  }

  function _triggerCooldown(Zombie storage _zombie) internal {
    _zombie.readyTime = uint32(now + cooldownTime);
  }

  function _isReady(Zombie storage _zombie) internal view returns (bool) {
      return (_zombie.readyTime <= now);
  }

  function feedAndMultiply(uint _zombieId, uint _targetDna, string _species) internal {
    require(msg.sender == zombieToOwner[_zombieId]);
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
</details>
<br>

---

## Chapter 8

```solidity
mapping (uint => uint) public age;

modifier olderThan(uint _age, uint _userId) {
  require (age[_userId] >= _age);
  _;
}

function driveCar(uint _userId) public olderThan(16, _userId) {

}
```

함수 제어자는 인수까지 받을 수 있다  

위 코드 같은 경우 `driveCar()` 함수가 실행되기 전에 `olderThan()` 함수 제어자가 먼저 실행된다  
이때 16과 `_userId`가 인수로 전달되는데 `olderThan()` 제어자의 코드가 실행되는 동안 전달 받은 인수를 사용한다  
<br>

---

## Chapter 9

```solidity
pragma solidity ^0.4.19;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

  modifier aboveLevel(uint _level, uint _zombieId) {
    require(zombies[_zombieId].level >= _level);
    _;
  }

  function changeName(uint _zombieId, string _newName) external aboveLevel(2, _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].name = _newName;
  }

  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].dna = _newDna;
  }

}
```
<br>

---

## Chapter 10

가스 최적화를 위해 `view` 함수를 사용할 수 있다  
<br>

> **View 함수는 가스를 소모하지 않는다**  
> `view` 함수는 블록체인 상의 데이터를 읽기만 하고 수정하지 않기 때문에 가스를 소모하지 않게 된다  
> 가능한 모든 곳에 읽기 전용인 `external view` 함수를 사용하는 것이 좋다  
> 
> *`pure` 함수 또한 외부에서 호출될 경우 가스를 소모하지 않는다*

`view` 함수가 같은 컨트랙트 내에 있는 `view` 함수가 아닌 다른 함수에서 내부적으로 호출하면 가스를 소모한다  
결국 다른 함수가 이더리움 상에 트랜잭션을 생성하고 모든 개별 노드에서 검증되어야 하기 때문이다  

즉, `view` 함수는 외부에서 호출되었을 때에만 가스가 소모되지 않는다  
<br>

---

```solidity
function getZombiesByOwner(address _owner) external view returns(uint[]) {
    
}
```
<br>

---

## Chapter 11

솔리디티에서 `storage`를 사용한 연산에 가스를 많이 소모한다  
그중에서도 쓰기 연산이 비싼 연산이다  

데이터를 새로 쓰거나 수정할 때 블록체인상에 영구적으로 기록되기 때문이다  
이를 최소화하기 위해 storage가 필요할 때만 사용하는 것이 좋다   

예를 들면 어떤 배열에서 내용을 빠르게 찾기 위해, 단순히 변수에 저장하지 않고 함수가 호출될 때마다 배열을 memory에 다시 만들 수 있다  
<br>

```solidity
pragma solidity ^0.4.19;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

  modifier aboveLevel(uint _level, uint _zombieId) {
    require(zombies[_zombieId].level >= _level);
    _;
  }

  function changeName(uint _zombieId, string _newName) external aboveLevel(2, _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].name = _newName;
  }

  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].dna = _newDna;
  }

  function getZombiesByOwner(address _owner) external view returns(uint[]) {
    uint[] memory result = new uint[](ownerZombieCount[_owner]);

    return result;
  }

}
```

<br>

> 메모리 배열은 storage 배열처럼 `array.push()`로 크기가 조절되지 않아 반드시 길이 인수와 함께 생성되어야 한다  
{: .prompt-warning}

<br>

---

## Chapter 12

```solidity
uint counter = 0;
for (uint i = 0; i < zombies.length; i++) {
  if (zombieToOwner[i] == _owner) {
    result[counter] = i;
    counter++;
  }
}
```

솔리디티에서 `for` 반복문은 자바스크립트 또는 C와 유사한 문법을 사용한다  
<br>

---

## Chapter 14

[내 좀비](https://share.cryptozombies.io/ko/lesson/3/share/%EA%B3%A0%EA%B0%84%EB%94%94?id=Y3p8NjU1MjE2)

