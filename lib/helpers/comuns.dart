dynamic dataHoraAtual() {
  dynamic dataAgora = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      DateTime.now().hour,
      DateTime.now().minute,
      DateTime.now().second);

  return dataAgora;
}
