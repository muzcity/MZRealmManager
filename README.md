# MZRealmManager

[![CI Status](http://img.shields.io/travis/muzcity/MZRealmManager.svg?style=flat)](https://travis-ci.org/muzcity/MZRealmManager)
[![Version](https://img.shields.io/cocoapods/v/MZRealmManager.svg?style=flat)](http://cocoapods.org/pods/MZRealmManager)
[![License](https://img.shields.io/cocoapods/l/MZRealmManager.svg?style=flat)](http://cocoapods.org/pods/MZRealmManager)
[![Platform](https://img.shields.io/cocoapods/p/MZRealmManager.svg?style=flat)](http://cocoapods.org/pods/MZRealmManager)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

MZRealmManager is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "MZRealmManager"
```

## Usage
해당 내용은 한글로 적어보려합니다.

해당 라이브러리는 swift 2.3에서 좀 쉽게 사용을 하려고 만들었습니다. (ㅠㅠ 아직 2.3 사용중이라는 뜻이죠.)

적용순서.

1. AppDelegate

```

func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
	// Override point for customization after application launch.

	// migration을 위한 준비작업을 합니다. 
	// realm에 저장하는 객체의 타입을 지정합니다.
	MZRealmManager.migrationList = [Foo.self]
	// 현재 정의한 스키마의 버전값을 입력합니다. (UInt64 type)
	MZRealmManager.SCHEMA_VERSION = 1

	return true
}

```

2. Realm을 사용하기위한 객체를 추가합니다.

~~~
import RealmSwift
import MZRealmManager


public class Foo : MZRealmBaseObject {
    dynamic var name : String = ""
    dynamic var time : Int = 0
    
    //schema version 1 에서 추가한 경우
    dynamic var cnt : Int = 100
    //schema version 2 에서 추가한 경우
    dynamic var firstName : String = ""
    
    //스키마가 버전이 올라갔을때 기존 버전에서 migration작업을 해주기 위한 메소드
    func migration(oldVersion : UInt64, oldObject:MigrationObject?, newObject:MigrationObject?) {
        
        switch oldVersion {
        case 0:  
        	newObject?["cnt"] = 1001
            break
        case 1:
	        newObject?["cnt"] = 1001
            newObject?["firstName"] = "abc"	        
            break
        default:
            newObject?["cnt"] = -1
            newObject?["firstName"] = "xyz"
            break
        }
    }
    
    func objectName() -> String {
        return Foo.className()
    }
    
}

~~~

3. 그외는 MZRealmManager의 메소드를 참고해주세요.
4. 아니면 샘픔을 참고해주세요.
5. 지금은 스위프트 2.3으로만 만들어져있습니다.




## Author

muzcity, muzcity@gmail.com

## License

MZRealmManager is available under the MIT license. See the LICENSE file for more info.
