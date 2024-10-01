// 환경에 따라 API URL 설정
// const String apiUrl = bool.fromEnvironment('dart.vm.product')
//     ? 'http://52.231.106.232:8000/api'  // 프로덕션 환경 flutter run --release
//     : 'http://10.0.2.2:8000/api';  // 디버그 환경(안드로이드) flutter run 

// 2024-10-01 현재 릴리즈 빌드시 에러발생 하여 release 옵션 대신 주석해제를 통해 변경합니다.
// const String apiUrl = 'http://52.231.106.232:8000/api';//프로덕션 환경(안드로이드) 
const String apiUrl = 'http://10.0.2.2:8000/api';//디버그 환경(안드로이드)
// const String apiUrl = 'http://127.0.0.1:8000/api';//디버그 환경(안드로이드)
