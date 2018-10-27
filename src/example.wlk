object paqueteMisterioso {
	var pagado = false
	method pagar()
	{ pagado = true }
	
	method puedellegar(mensajero, destino)
	{ return destino.dejapasar(mensajero) && pagado }
}

object brooklyn {
	 method dejapasar(mensajero)
	 { return mensajero.peso() <= 1000 }
}

object matrix {
	method dejapasar(mensajero)
	{ return mensajero.llamada() }
}

object roberto {
	var peso = 90
	var vehiculo
	method llamada()
	{ return false }
	
	method viaje(transporte)
	{ vehiculo = transporte }
	
	method peso()
	{ return peso + vehiculo.peso() }
}

object jenny {
	method peso()
	{ return 0 }
}

object mack {
	var acoplados = 0
	method nuevoacoplado(cantidad)
	{ acoplados = acoplados + cantidad }
	
	method peso()
	{ return 500 * acoplados }
}

object chucknorris {
	method llamada()
	{ return true }
	
	method peso()
	{ return 900 }
}

object neo {
	var credito = 10
	method peso()
	{ return 0 }
	
	method llamada()
	{ return credito > 0 }
	
	method recarga(pesos)
	{ credito = credito + pesos }
}