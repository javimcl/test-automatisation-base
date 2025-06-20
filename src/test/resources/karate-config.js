function fn() {
  var env = karate.env || 'dev';

  // Configuración base
  var config = {
    baseUrl: 'http://bp-se-test-cabcd9b246a5.herokuapp.com',
    env: env
  };

  return config;
}
