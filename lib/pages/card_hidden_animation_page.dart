import 'dart:math';

import 'package:flutter/material.dart';

// ! Определение StatefulWidget, который будет управлять анимацией
class CardHiddenAnimationPage extends StatefulWidget {
  const CardHiddenAnimationPage({Key? key}) : super(key: key);

  @override
  State<CardHiddenAnimationPage> createState() => CardHiddenAnimationPageState();
}

// ! Определение состояния для StatefulWidget
class CardHiddenAnimationPageState extends State<CardHiddenAnimationPage> with TickerProviderStateMixin {
  final cardSize = 150.0;

  // ! Определение анимаций и контроллеров анимации
  // Объект Tween, который определяет интерполяцию между двумя значениями (в данном случае, между 0 и 1.5 * cardSize). Это будет использоваться для анимации размера "черной дыры".
  late final holeSizeTween = Tween<double>(
    begin: 0,
    end: 1.5 * cardSize,
  );

  // Контроллер анимации, который управляет прогрессом анимации. В данном случае, он настроен на продолжительность 300 миллисекунд.
  late final holeAnimationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  // Геттер, который вычисляет текущий размер "черной дыры" на основе текущего значения
  double get holeSize => holeSizeTween.evaluate(holeAnimationController);

  // Еще один контроллер анимации, который будет использоваться для анимации смещения карточки. Он настроен на продолжительность 1000 миллисекунд.
  late final cardOffsetAnimationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );

  // Объекты Tween, которые определяют интерполяцию между двумя значениями для смещения, вращения и высоты карточки соответственно. Они связаны с CurveTween для добавления эффекта замедления в конце анимации (Curves.easeInBack).
  late final cardOffsetTween = Tween<double>(
    begin: 0,
    end: 2 * cardSize,
  ).chain(CurveTween(curve: Curves.easeInBack));
  late final cardRotationTween = Tween<double>(
    begin: 0,
    end: 3.5,
  ).chain(CurveTween(curve: Curves.easeInBack));
  late final cardElevationTween = Tween<double>(
    begin: 2,
    end: 20,
  );

  // Геттеры, которые вычисляют текущее смещение, вращение и высоту карточки на основе текущего значения cardOffsetAnimationController.
  double get cardOffset =>
      cardOffsetTween.evaluate(cardOffsetAnimationController);
  double get cardRotation =>
      cardRotationTween.evaluate(cardOffsetAnimationController);
  double get cardElevation =>
      cardElevationTween.evaluate(cardOffsetAnimationController);

  // Инициализация контроллеров анимации
  @override
  void initState() {
    holeAnimationController.addListener(() => setState(() {}));
    cardOffsetAnimationController.addListener(() => setState(() {}));
    super.initState();
  }

  // Удаление контроллеров анимации при удалении виджета
  @override
  void dispose() {
    holeAnimationController.dispose();
    cardOffsetAnimationController.dispose();
    super.dispose();
  }

  // ! Построение UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () async {
              // ! Начинает анимацию "черной дыры", увеличивая ее размер.
              holeAnimationController.forward();

              // ! Начинает анимацию смещения карточки, перемещая ее вниз. Это действие ожидает завершения анимации перед продолжением.
              await cardOffsetAnimationController.forward();

              // ! После задержки в 200 миллисекунд, анимация "черной дыры" возвращается обратно, уменьшая ее размер.
              Future.delayed(const Duration(milliseconds: 200),
                  () => holeAnimationController.reverse());
            },
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            onPressed: () {
              // ! reverse() на обоих анимациях, возвращая карточку и "черную дыру" в их исходное состояние.
              cardOffsetAnimationController.reverse();
              holeAnimationController.reverse();
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          height: cardSize * 1.25,
          width: double.infinity,
          child: ClipPath(
            clipper: BlackHoleClipper(),
            child: Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  width: holeSize,
                  child: Image.asset(
                    'images/hole.png',
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  child: Center(
                    child: Transform.translate(
                      offset: Offset(0, cardOffset),
                      child: Transform.rotate(
                        angle: cardRotation,
                        child: const Card(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ! Определение CustomClipper для создания эффекта "черной дыры"
// Класс используется для создания пользовательского обрезчика, который определяет, как будет выглядеть область обрезки для виджета.
class BlackHoleClipper extends CustomClipper<Path> {

  // Это метод, который возвращает объект Path, определяющий область обрезки. В этом методе создается новый Path и добавляются различные операции для определения формы обрезки.
  @override
  Path getClip(Size size) {
    final path = Path();
    
    path.moveTo(0, size.height / 2); // Перемещает начальную точку пути в середину высоты области обрезки.

    // Добавляет дугу к пути. Дуга определяется прямоугольником, который создается с помощью Rect.fromCenter(). 
    // Центр прямоугольника находится в середине области обрезки, а его ширина и высота равны ширине и высоте области обрезки. 
    // Дуга начинается с 0 радиан и заканчивается на pi радиан (полукруг).
    path.arcTo(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width,
        height: size.height,
      ),
      0,
      pi,
      true,
    );

    // Добавляют линии к пути, которые идут от конца дуги до верхней части области обрезки. 
    // Значение -1000 используется для гарантии того, что область обрезки будет достаточно большой, 
    // чтобы включить в себя всю карточку, независимо от ее высоты.
    path.lineTo(0, -1000);
    path.lineTo(size.width, -1000);

    path.close(); // Замыкает путь, соединяя последнюю точку пути с первой точкой.
    return path;
  }

  // Это метод, который вызывается каждый раз, когда Flutter должен решить, нужно ли создать новый экземпляр обрезчика. 
  // В этом случае он всегда возвращает false, что означает, что новый обрезчик не нужен, когда обновляется виджет, который использует этот обрезчик.
  @override
  bool shouldReclip(BlackHoleClipper oldClipper) => false;
}

// ! Определение виджета Card, который будет анимирован
class Card extends StatelessWidget {
  const Card({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset('images/gen.png'),
    );
  }
}