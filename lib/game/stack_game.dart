import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/material.dart';

class StackGame extends FlameGame with TapDetector {
  late Block currentBlock;
  List<Block> tower = [];
  double towerHeight = 0;
  int score = 0;
  bool gameOver = false;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    addBackground();
    spawnNewBlock();
  }

  void addBackground() {
    add(RectangleComponent(
      position: Vector2(0, 0),
      size: size,
      paint: Paint()..color = const Color(0xFF1E1E2E),
    ));
  }

  void spawnNewBlock() {
    currentBlock = Block(
      position: Vector2(size.x / 2 - 50, 100),
      size: Vector2(100, 30),
    );
    add(currentBlock);
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (gameOver) return;

    if (currentBlock.isSwinging) {
      currentBlock.drop();
    }
  }

  void placeBlock() {
    tower.add(currentBlock);
    towerHeight += currentBlock.size.y;
    score += 10;

    // Check perfect stack
    if (tower.length > 1) {
      final prev = tower[tower.length - 2];
      if ((currentBlock.position.x - prev.position.x).abs() < 10) {
        score += 5; // bonus
      }
    }

    spawnNewBlock();
  }

  void endGame() {
    gameOver = true;
    // TODO: show game over overlay
  }
}

class Block extends PositionComponent with HasGameRef<StackGame> {
  bool isSwinging = true;
  double swingSpeed = 3.0;
  double direction = 1.0;

  Block({required super.position, required super.size});

  @override
  void update(double dt) {
    super.update(dt);
    if (isSwinging) {
      position.x += swingSpeed * direction;

      if (position.x > gameRef.size.x - size.x || position.x < 0) {
        direction *= -1;
      }
    }
  }

  void drop() {
    isSwinging = false;
    // Simulate falling with simple gravity in update or use physics later
    gameRef.placeBlock();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = Colors.orange,
    );
  }
}