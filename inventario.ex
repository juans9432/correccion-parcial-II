defmodule Inventario do
  alias Pieza
  alias Movimiento

  #funcion que aplica movimientos a las piezas
  def aplicar_movimientos(piezas, movimientos) do
    movimientos_por_pieza =
      Enum.group_by(movimientos, fn m -> m.codigo end)
    Enum.map(piezas, fn pieza ->
      movs = Map.get(movimientos_por_pieza, pieza.codigo, [])
      nuevo_stock =
        Enum.reduce(movs, pieza.stock, fn mov, acc ->
          case mov.tipo do
            "ENTRADA" -> acc + mov.cantidad
            "SALIDA" -> acc - mov.cantidad
            _ -> acc
          end
        end)

      %{pieza | stock: nuevo_stock}
    end)
  end

  # Función recursiva que suma las cantidades movidas entre dos fechas
  def total_movido_en_rango([], _fini, _ffin), do: 0

  def total_movido_en_rango([%Movimiento{fecha: fecha, cantidad: cantidad} | tail], fini, ffin) do
    if fecha >= fini and fecha <= ffin do
      cantidad + total_movido_en_rango(tail, fini, ffin)
    else
      total_movido_en_rango(tail, fini, ffin)
    end
  end


end
