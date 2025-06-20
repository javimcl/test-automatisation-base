@REQ_AAA-1088  @ExcepcionAAA-1088
Feature: ExcepcionAAA-1088

  Background:
    * def uniqueName = 'Iron Man ' + java.util.UUID.randomUUID()
    * def body =
      """
      {
        "name": "#(uniqueName)",
        "alterego": "Tony Stark",
        "description": "Genius billionaire",
        "powers": ["Armor", "Flight"]
      }
      """
    * karate.set('sharedCharacterId', null)

  @id:1 @ObtenerTodosPersonajes
  Scenario Outline: T-API-AAA-1088-CA1- Obtener todos los personajes
    Given url baseUrl + '/testuser/api/characters'
    When method GET
    Then status 200
    * print response
    Examples:
      | prueba |
      | 1     |

  @id:2 @ObtenerPorIdNoExistente
  Scenario Outline: T-API-AAA-1088-CA2- Obtener personaje por ID no existente
    Given url baseUrl + '/testuser/api/characters/9999'
    When method GET
    Then status 404
    * print response
    Examples:
      | prueba |
      | 1     |

  @id:3 @CrearPersonajeExitoso
  Scenario Outline:  T-API-AAA-1088-CA3 - Crear personaje exitoso
    * configure ssl = true
    * header content-type = 'application/json'
    Given url baseUrl + '/testuser/api/characters'
    And request body
    When method POST
    Then status 201
    And print response
    * def createdId = response.id
    * karate.set('sharedCharacterId', createdId)
    * print 'ID creado y guardado globalmente:', createdId
    
    # Guardar el ID en archivo CSV
    * def timestamp = new java.util.Date().toString()
    * def csvLine = '\n' + createdId + ',' + timestamp + ',CA3-Crear_personaje_exitoso'
    * def FileUtils = Java.type('org.apache.commons.io.FileUtils')
    * def File = Java.type('java.io.File')
    * def csvFile = new File('src/test/resources/data/bodyEjecutado.csv')
    * FileUtils.writeStringToFile(csvFile, csvLine, 'UTF-8', true)
    Examples:
      | prueba |
      | 1     |

  @id:4 @ObtenerPorIdExitoso
  Scenario Outline: T-API-AAA-1088-CA4- Obtener personaje por ID exitoso
    # Leer el ID desde el archivo CSV
    * def FileUtils = Java.type('org.apache.commons.io.FileUtils')
    * def File = Java.type('java.io.File')
    * def csvFile = new File('src/test/resources/data/bodyEjecutado.csv')
    * def csvContent = FileUtils.readFileToString(csvFile, 'UTF-8')
    * def lines = csvContent.split('\n')
    * def lastLine = lines[lines.length - 1]
    * def csvData = lastLine.split(',')
    * def createdId = csvData[0]
    * print 'ID leído desde CSV:', createdId
    * if (createdId == null || createdId == 'id') karate.fail('ID no encontrado en el archivo CSV, debe ejecutar primero el escenario 3')
    Given url baseUrl + '/testuser/api/characters/'  + createdId
    When method GET
    Then status 200
    * print response
    Examples:
      | prueba |
      | 1     |

  @id:5 @CrearPersonajeNombreDuplicado
  Scenario Outline:  T-API-AAA-1088-CA5 - Crear personaje con nombre duplicado
    * configure ssl = true
    * header content-type = 'application/json'
    Given url baseUrl + '/testuser/api/characters'
    And def user = read('classpath:/data/body.json')
    And request user
    When method POST
    Then status 400
    And print response
    Examples:
      | prueba |
      | 1     |

  @id:6 @CrearPersonajeCamposObligatorios
  Scenario Outline:  T-API-AAA-1088-CA6 - Crear personaje con campos obligatorios
    * configure ssl = true
    * header content-type = 'application/json'
    Given url baseUrl + '/testuser/api/characters'
    And def user = read('classpath:/data/bodyVacio.json')
    And request user
    When method POST
    Then status 400
    And print response
    Examples:
      | prueba |
      | 1     |

  @id:7 @ActualizarPersonajeExitoso
  Scenario Outline:  T-API-AAA-1088-CA7 - Actualizar personaje exitoso
    * configure ssl = true
    * header content-type = 'application/json'
    # Leer el ID desde el archivo CSV
    * def FileUtils = Java.type('org.apache.commons.io.FileUtils')
    * def File = Java.type('java.io.File')
    * def csvFile = new File('src/test/resources/data/bodyEjecutado.csv')
    * def csvContent = FileUtils.readFileToString(csvFile, 'UTF-8')
    * def lines = csvContent.split('\n')
    * def lastLine = lines[lines.length - 1]
    * def csvData = lastLine.split(',')
    * def createdId = csvData[0]
    * print 'ID leído desde CSV para actualizar:', createdId
    * if (createdId == null || createdId == 'id') karate.fail('ID no encontrado en el archivo CSV, debe ejecutar primero el escenario 3')
    Given url baseUrl + '/testuser/api/characters/' + createdId
    And request body
    When method PUT
    Then status 200
    And print response
    Examples:
      | prueba |
      | 1     |

  @id:8 @ActualizarPersonajeNoExistente
  Scenario Outline:  T-API-AAA-1088-CA8 - Actualizar personaje no existente
    * configure ssl = true
    * header content-type = 'application/json'
    Given url baseUrl + '/testuser/api/characters/' + '9999'
    And request body
    When method PUT
    Then status 404
    And print response
    Examples:
      | prueba |
      | 1     |

  @id:9 @EliminarPersonajeExitoso
  Scenario Outline:  T-API-AAA-1088-CA9 - Eliminar personaje exitoso
    * configure ssl = true
    * header content-type = 'application/json'
    # Leer el ID desde el archivo CSV
    * def FileUtils = Java.type('org.apache.commons.io.FileUtils')
    * def File = Java.type('java.io.File')
    * def csvFile = new File('src/test/resources/data/bodyEjecutado.csv')
    * def csvContent = FileUtils.readFileToString(csvFile, 'UTF-8')
    * def lines = csvContent.split('\n')
    * def lastLine = lines[lines.length - 1]
    * def csvData = lastLine.split(',')
    * def createdId = csvData[0]
    * print 'ID leído desde CSV para eliminar:', createdId
    * if (createdId == null || createdId == 'id') karate.fail('ID no encontrado en el archivo CSV, debe ejecutar primero el escenario 3')
    Given url baseUrl + '/testuser/api/characters/' + createdId
    When method DELETE
    Then status 204
    And print response
    Examples:
      | prueba |
      | 1     |

  @id:10 @EliminarPersonajeNoExistente
  Scenario Outline:  T-API-AAA-1088-CA10 - Eliminar personaje no existente
    * configure ssl = true
    * header content-type = 'application/json'
    Given url baseUrl + '/testuser/api/characters/' + '9999'
    When method DELETE
    Then status 404
    And print response
    Examples:
      | prueba |
      | 1     |
      | prueba |
      | 1     |