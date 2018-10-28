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
/*	2:
	Empresa de mensajería, Ahora aparece una empresa de mensajería, Fedax.
	Esta tiene un conjunto de mensajeros, los cuales podrían ser:
	Roberto, Chuck y Neo.
	
	Se necesita poder hacer:
	* 1.contratar a un mensajero
	* 2.despedir a un mensajero
	* 3.despedir a todos los mensajeros
	* 4.Analizar si Fedax es grande (si tiene más de 2 mensajeros)
	* 5.Consultar si el paquete puede ser entregado por el primer empleado de la empresa. 
	* 6.Saber el peso del último mensajero de la empresa.
	* 7.Hacer algunos test significativos.
	ver cada punto en las referencias 2.X)
*/

/*	3: Mensajería  recargada
	Nuevos requerimientos para la mensajería.
	* 
	Se necesita saber:
	1.Si el paquete puede ser entregado por la empresa de mensajería,
		es decir, si al menos uno de sus mensajeros puede entregar el paquete.
	2.Si para la empresa de mensajería el paquete es fácil.
		El paquete es fácil cuando cualquiera de sus mensajeros puede entregarlo.
	3.Saber los mensajeros candidatos de una mensajería para llevar
		un paquete, es decir, aquellos mensajeros que son capaces de
		llevar el paquete.
	4.Saber si una mensajería tiene sobrepeso. Esto sucede si el
		promedio del peso de los mensajeros es superior a 500 Kg
		(Nota: Para el peso de Roberto se cuenta el transporte).
	5.Hacer que la empresa de mensajería envíe un paquete. Para ello
		elige cualquier mensajero entre los que pueden enviarlo, y registra
		que fue enviado. En el caso de no haber nadie para enviarlo, debe
		informarse con un error descriptivo.
	6.Hacer algunos test significativos.
	ver cada punto en las referencias 3.X)
*/
object paquete{
	var estaPago = false
	var destino = pBrooklyn
	const precioBase = 50
	
	method pagarPaquete() 		{estaPago = true}
	method estaPago() 			{return estaPago}
	method enviarDestino(lugar) {destino = lugar}
	
	//fragmento necesario para la parte 3(al menos 1 puede entregarlo?)
	method puedeSerEntregadoPor(mensajero) {
		return destino.dejaPasar(mensajero) and self.estaPago()
	}
}

object empresaMensajeria {
	var mensajeros = []
	var entregados = []
	//2.1)contratar a uno(el parametro es un elemento nuevo para la lista)
	method contratar(empleado){
		mensajeros.add(empleado)
	}
	//2.1)contratar a todos(el parametro es una lista de empleados)
	method contratarATodos(empleados) {
		mensajeros.addAll(empleados)
	}
	//2.2)despedir a uno
	method despedirA(empleado) {
		mensajeros.remove(empleado)
	}
	//2.3)despedir a todos
	method despedirATodos() {
		mensajeros.clear()
	}
	//2.4) fedax es grande?
	method esGrande(){
		return mensajeros.size() > 2
	}
	//2.5)el primero puede entregar el paquete?
	method elPrimeroPuedeEntregar() {
		return paquete.puedeSerEntregadoPor(mensajeros.first())
	}
	//2.5)el peso del ultimo?
	method pesoDelUltimo(){
		return mensajeros.last().peso()
	}
	
	//solo para testear
	method mensajeros(){
		return mensajeros
	}
	//solo para testear
	method entregados() {
		return entregados
	}
	
	
	//3.1)al menos 1 puede entregarlo?
	method algunoPuedeEntregar() {
		return mensajeros.any({mensajero => paquete.puedeSerEntregadoPor(mensajero)})
	}
	//3.2)es un paquete facil?(todos pueden entregarlo)
	method paqueteFacil() {
		return mensajeros.all({mens=>paquete.puedeSerEntregadoPor(mens)})
	}
	//3.3)Saber que mensajeros de la empresa, son los candidatos que pueden
	//	  llevar un paquete
	method candidatosPara() {
		return mensajeros.filter({mensajero => paquete.puedeSerEntregadoPor(mensajero)})
	}
	//3.4)Saber si una mensajería tiene sobrepeso.
	//	  Esto sucede si el promedio del peso de los mensajeros
	//	  es superior a 500 Kg
	method tieneSobrepeso(){
		return self.pesoPromedio() > 500
	}
	method pesoPromedio(){
		return self.pesoTotal() / mensajeros.size()
	}
	method pesoTotal(){
		return mensajeros.sum( { mensajero => mensajero.peso() } )
	}
	//3.5)Hacer que la empresa de mensajería envíe un paquete.
	//	  Para ello elige cualquier mensajero entre los que
	//	  pueden enviarlo, y registra que fue enviado.
	//	  En el caso de no haber nadie para enviarlo, debe
	//	  informarse con un error descriptivo.
	method enviarPaquete(){
		if (not self.algunoPuedeEntregar())  
			error.throwWithMessage("No hay mensajeros disponibles")
		entregados.add(paquete)
	}
}






























