class Comensal{
	const property nombre
	
	var property elementosCerca = []
	
	var property criterioPersonal
	
	var property comidaIngerida = []
	
	var property tipoDeAlimentacion
	
	method acercarObjeto(elemento) = elementosCerca.add(elemento)
	
	method deshacerseDeObjeto(elemento) = elementosCerca.remove(elemento)
	
	// Punto 1
	
	method tengoElementoCerca(elemento) = elementosCerca.contains(elemento)
	
	method pasarElementoA(elemento, solicitado, comensal){
		if(solicitado.tengoElementoCerca(elemento)){
			criterioPersonal.pasarElementoA(elemento, self, comensal) 
		}else{
			throw new NoTengoElementoException(message = "El comensal al cual se le solicito el elemento no lo tiene a mano")
		}
	}
	
	// Punto 2
	
	method comerDe(bandeja) = tipoDeAlimentacion.comerDe(bandeja)
	
	method ingerirComida(comensal, comida) = comidaIngerida.add(self, comida)
	
	// Punto 3
	
	method pipon() = comidaIngerida.any({comida => comida.esPesada()})
	
	// Punto 4 
	
	method laPasoBien(){
		if(!comidaIngerida.isEmpty()){
			if(nombre == "Facu"){
				comidaIngerida.any({comida => comida.esCarne()})
			}else if(nombre == "Vero"){
				elementosCerca.size() < 3
			}
		}else self.error("El comensal la paso mal")
	}
}

object normal{
	method pasarElementoA(elemento, solicitado, solicitador){
			solicitador.acercarObjeto(elemento)
			solicitado.deshacerseDeObjeto(elemento)
	}
}

object intranquilo{
	method pasarElementoA(elemento, solicitado, solicitador){
		solicitado.elementosCerca().forEach({objeto => solicitador.acercarObjeto(objeto)
													   solicitado.deshacerseDeObjeto(objeto)})	
	}
}

object sordo{
	method pasarElementoA(elemento, solicitado, solicitador){
		const primerElemento = solicitado.elementosCerca().first()
		solicitador.acercarObjeto(primerElemento)
		solicitado.deshacerseDeObjeto(primerElemento)
	}
}

object cambiarPosiciones{
	method pasarElementoA(elemento, solicitado, solicitador){
		const elementosDelSolicitador = solicitador.elementosCerca()
		const elementosDelSolicitado = solicitado.elementosCerca()
		solicitador.elementosCerca(elementosDelSolicitado)
		solicitado.elementosCerca(elementosDelSolicitador)
	}
}

// ---------------------- Tipo de comida ---------------------- 

class BandejaDeComida{
	const property comida
}

class Alimentos{
	const property calorias
	
	method esPesada() = calorias > 500
	
	method esCarne() = false
}

class Carne inherits Alimentos{
	override method esCarne() = true
}

// ---------------------- Tipo de alimentacion ---------------------- 

object vegetariano{
	method comerDe(comensal, bandeja){
		if(bandeja.comida().esCarne()){
			throw new VegetarianoNoComeCarneException(message = "Los vegetarianos no pueden comer carne")
		}else comensal.ingerirComida(bandeja.comida())
	}
}

object dietetico{
	method comerDe(comensal, bandeja){
		if(bandeja.comida().calorias() < 500){
			comensal.ingerirComida(bandeja.comida())
		}else throw new AlimentoAltamenteCaloricoException(message = "El alimento posee mas de 500 calorias")
	}
}

object alternado{
	method aceptarComida() = 0.randomUpTo(2).roundUp().even()
	
	method comerDe(comensal, bandeja){
		if(!self.aceptarComida()){
			throw new IncumplimientoDeCondicionesException(message = "No se ha cumplido con todas las condiciones para comer")
		}else comensal.ingerirComida(bandeja.comida())
	}
}


/// EXCEPCIONES

class NoTengoElementoException inherits Exception{}
class VegetarianoNoComeCarneException inherits Exception{}
class AlimentoAltamenteCaloricoException inherits Exception{}
class IncumplimientoDeCondicionesException inherits Exception{}