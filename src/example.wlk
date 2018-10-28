object paqueteMisterioso {
	var pagado = false
	method pagar()
	{ pagado = true }
	
	method puedellegar(mensajero, destino)
	{ return destino.dejapasar(mensajero) && pagado }
}

//Puente de Brooklyn: deja pasar a todo lo que pese hasta una tonelada.
object pBrooklyn {
	 method dejaPasar(mensajero)
	 { return mensajero.peso() <= 1000 }
}
//La Matrix: deja entrar a quien pueda hacer una llamada.
object laMatrix {
	method dejaPasar(mensajero)
	{ return mensajero.llamada() }
}

//Roberto: Roberto viaja en su bici ó en su camión.
//Si viaja con su bici, el peso que cuenta es el suyo propio.
//Si viaja con el camion, su peso más media tonelada por cada acoplado que le ponga.
//Roberto no tiene un mango (gracias que tiene cubiertas...), y no puede
//llamar a nadie.
object roberto {
	var vehiculo
	method viaje(transporte)		{ vehiculo = transporte }

	method peso()					{ return 90 + vehiculo.peso() }

	method llamada()				{ return false }
}
object bici {
	method peso()					{ return 0 }
}

object camion {
	var acoplados = 0
	method nuevoacoplado(cantidad)	{ acoplados = acoplados + cantidad }
	method peso()					{ return 500 * acoplados }
}
//Chuck Norris: Chuck norris pesa 900 kg y puede llamar a cualquier
//persona del universo con sólo llevarse el pulgar al oído y el
//meñique a la boca
object chucknorris {
	method peso()		{ return 900 }

	method llamada()	{ return true }
}
//Neo vuela, así que no pesa nada. Y anda con celular, el muy canchero.
//El tema es que a veces no tiene crédito.
object neo {
	var credito = 0
	method peso()			{ return 0 }

	method recarga(recarga)	{ credito = credito + recarga }

	method llamada()		{ return credito > 0 }
}

































