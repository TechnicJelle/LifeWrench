class Button {
  PVector pos;
  PVector size;
  String label;

  Button(float x, float y, float w, float h, String text) {
    pos = new PVector(x, y);
    size = new PVector(w, h);
    label = text;
  }

  void render() {
    render(360);
  }

  void render(int b) {
    fill(b, 180);
    stroke(0);
    strokeWeight(3);
    rect(pos.x, pos.y, size.x, size.y, btnSize/10);

    fill(0);
    textBox(label, pos.x, pos.y, size.x, size.y);
  }

  boolean isClicked() {
    return isClicked(new PVector(mouseX, mouseY));
  }

  boolean isClicked(PVector cp) {
    return cp.x > pos.x && cp.x < pos.x + size.x
      && cp.y > pos.y && cp.y < pos.y + size.y;
  }
}
