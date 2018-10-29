//Puente de Brooklyn: deja pasar a todo lo que pese hasta una tonelada.
object pBrooklyn {
	method dejaPasar(mensajero){ return mensajero.peso() <= 1000 }
}
//La Matrix: deja entrar a quien pueda hacer una llamada.
object laMatrix {
	method dejaPasar(mensajero){ return mensajero.llamada() }
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
/*	2: Empresa de mensajería
	Ahora aparece una empresa de mensajería, Fedax.
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
	
	method pagarPaquete() 		{estaPago = true}
	method estaPago() 			{return estaPago}
	method enviarDestino(lugar) {destino = lugar}

	//fragmento necesario para la parte 3
	method puedeSerEntregadoPor(mensajero) {
		return destino.dejaPasar(mensajero) and self.estaPago()
	}
	method precio() = 50
}

object empresaMensajeria {
	var mensajeros = []
	var entregados = []
	var pendientes = [paquete,paquetin,paqueton]
	
	method cantMensajeros() =	mensajeros.size()
	method cantPaqEntr() =		entregados.size()
	method cantPaqPend() =		pendientes.size()
	
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

	//3.1)al menos 1 puede entregarlo?
	method algunoPuedeEntregar(paquete) {
		return mensajeros.any({mensajero => paquete.puedeSerEntregadoPor(mensajero)})
	}
	//3.2)es un paquete facil?(todos pueden entregarlo)
	method paqueteFacil(paquete) {
		return mensajeros.all({mensajero => paquete.puedeSerEntregadoPor(mensajero)})
	}
	//3.3)Saber que mensajeros de la empresa, son los candidatos que pueden
	//	  llevar un paquete
	method candidatosPara(paquete) {
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
	method enviar(paquete){
		if (not self.algunoPuedeEntregar(paquete))
			error.throwWithMessage("No hay mensajeros disponibles")
		entregados.add(paquete)
		pendientes.remove(paquete)
	}
	/*A su vez, hay nuevos requerimientos para la mensajeria:
	Hacer que se envien todos los paquetes recibidos que se puedan enviar,
	registrándolos adecuadamente(listas de entregados y pendientes)*/
	method enviarTodos() {
		self.paquetesAEnviar().forEach{paquete => self.enviar(paquete)}
	}
	method paquetesAEnviar(){
		return pendientes.filter{paquete => self.algunoPuedeEntregar(paquete)}
	}
	/*Encontrar el paquete más caro.
	(el paquete original tiene un precio determinado en $50)*/
	method paqueteMasCaro(){
		return pendientes.max{paquete => paquete.precio()}
	}
}
//Paquetito
object paquetin {
	//Cualquier mensajero lo puede llevar.
	method puedeSerEntregadoPor(mensajero)	{return true}
	//Es gratis, o sea, no hace falta veriricar si este pago.
	method precio() 						{return 0}
}
//Paqueton:
object paqueton {
	//Debe poder pasar por muchos destinos(una lista de ellos).
	var destinos = []
	//Su precio es 100$ por cada destino.
	var precioBase = 100
	var importePagado = 0
	//Se puede ir pagando parcialmente y se debe pagar totalmente para poder ser enviado.
	method quitarDestino(dest)	 {destinos.remove(dest)}
	method borrarDestinos()		 {destinos.clear()}
	method agregarDestino(dest)	 {destinos.add(dest)}
	method agregarDestinos(dests){destinos.addAll(dests)}
	
	method pagoParcial()		 {importePagado += 100}
	
	method precio() {return destinos.size()*precioBase}
	
	method estaPago()			 {return importePagado >= self.precio()}

	//el paqueton puede ser entregado, si pasa por todos los destinos de la lista, y si esta
	//totalmente pagado.
	method puedeSerEntregadoPor(mensajero)
	{return self.puedePasarPorDestinos(mensajero) && self.estaPago()}
	
	method puedePasarPorDestinos(mensajero)
	{return destinos.all{ destino => destino.dejarPasar(mensajero) }}
}