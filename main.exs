defmodule Main do
  alias Pieza
  alias Movimiento
  alias Inventario

  def main do
    p1 = Pieza.crear("COD123", "Resistor", 47, "ohm", 120)
    p2 = Pieza.crear("COD124", "Capacitor", 100, "uF", 35)
    p3 = Pieza.crear("COD124", "Capacitor", 100, "uF", 35)

    piezas = [p1, p2, p3]

    IO.puts("Inventario inicial:")
    IO.inspect(piezas)

    m1 = Movimiento.crear("COD123", "ENTRADA", 50, "2025-09-10")
    m2 = Movimiento.crear("COD124", "SALIDA", 10, "2025-09-12")

    movimientos = [m1, m2]

    IO.puts("\n Movimientos registrados:")
    IO.inspect(movimientos)

    IO.puts("\n Aplicando movimientos...")
    inventario_actualizado = Inventario.aplicar_movimientos(piezas, movimientos)
    IO.puts(" Inventario actualizado correctamente:")
    IO.inspect(inventario_actualizado)

    Pieza.guardar_inventario("inventario_actual.csv", inventario_actualizado)

    Movimiento.guardar("movimientos.csv", movimientos)

    fini = "2025-10-01"
    ffin = "2025-10-03"

    total = Inventario.total_movido_en_rango(movimientos, fini, ffin)
    IO.puts("\n Total de unidades movidas entre #{fini} y #{ffin}: #{total}")

    t = 45
    total_piezas = Pieza.contar(piezas, t)
    IO.puts("\nTotal de piezas con stock menor a #{t}: #{total_piezas}")


    sin_duplicados = Pieza.eliminar_duplicados(piezas)
    IO.puts("Lista sin duplicados:")
    IO.inspect(sin_duplicados)

    n = 7
    IO.puts("Calculando f(#{n}) en ComplejoB...\n")
    resultado = ComplejoB.f(n)
    IO.puts("\nResultado final: #{resultado}")

  end
end


Main.main()
