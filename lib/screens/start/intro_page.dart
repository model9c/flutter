import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:tamoi/constants/common_size.dart';
import 'package:tamoi/states/user_provider.dart';
import 'package:tamoi/utils/logger.dart';
import 'package:provider/provider.dart';

class IntroPage extends StatelessWidget {

  IntroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.d('current user state: ${context.read<UserProvider>().userState}');
    return LayoutBuilder(
      // 화면의 전체적인 레이아웃을 컨트롤 할 수 있다.
      builder: (context, constraints) {
        Size size = MediaQuery.of(context).size;
        final imgSize = size.width - (common_padding * 2);
        final sizeofPosImg = imgSize * 0.1;

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: common_padding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('TAMOI',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium! // headline3 자체가 null 을 허용하기 때문에 !를 붙여서 null이 아니라고 선언
                        .copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .primary)), // 모든 테마를 카피하되 컬러만 primary컬러로 해라
                SizedBox(
                  width: imgSize,
                  height: imgSize,
                  child: Stack(
                    children: [
                      ExtendedImage.asset('assets/imgs/carrot_intro.png'),
                      Positioned(
                          width: sizeofPosImg,
                          left: imgSize * 0.45,
                          top: imgSize * 0.45,
                          height: sizeofPosImg,
                          // 가운데 사이즈는 0.1(10%의 사이즈를 할당한다.
                          child: ExtendedImage.asset(
                              'assets/imgs/carrot_intro_pos.png')),
                      // left / top / right / bottom 옵션은 padding을 의미
                      // left - right - width // top - bottom - height  은 두개의 값만 줘야함 -> left + width (O) left + right + width (X)
                    ],
                  ),
                ),
                Text('낚시/캠핑/레저를 한번에!!',
                    style: Theme.of(context).textTheme.labelMedium),
                Text('통합 마켓 플랫폼 입니다.\n동네를 인증하고 시작하세요!',
                    style: Theme.of(context).textTheme.labelMedium),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextButton(
                      onPressed: () async {
                        context.read<PageController>().animateToPage(1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease);
                        logger.d('on text button clicked!!!');
                        // var response = await Dio().get('https://randomuser.me/api/');
                        // logger.d(response);
                      },
                      // style: TextButton.styleFrom(
                      //     backgroundColor: Theme.of(context).primaryColor),
                      child: Text(
                        '내 동네 설정하고 시작하기',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
