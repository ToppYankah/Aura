class ModalOptions {
  final String? title;
  final bool useHorizontalPadding;
  final bool backgroundDismissible;

  const ModalOptions({
    this.title,
    this.useHorizontalPadding = true,
    this.backgroundDismissible = false,
  });
}
