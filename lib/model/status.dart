enum StatusPedido { finalizado, emPreparacao, aCaminho, entregue, cancelado }

String statusToString(StatusPedido status) {
  return status.toString().split('.').last;
}

StatusPedido stringToStatus(String statusString) {
  switch (statusString) {
    case 'finalizado':
      return StatusPedido.finalizado;
    case 'em Preparacao':
      return StatusPedido.emPreparacao;
    case 'a Caminho':
      return StatusPedido.aCaminho;
    case 'entregue':
      return StatusPedido.entregue;
    case 'cancelado':
      return StatusPedido.cancelado;
    default:
      return StatusPedido.emPreparacao;
  }
}
