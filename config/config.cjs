require('dotenv').config();

const hasPostgresConfig = Boolean(
  process.env.DATABASE_URL
  || (
    process.env.DATABASE_HOST
    && process.env.DATABASE_NAME
    && process.env.DATABASE_USERNAME
  ),
);

const getPostgresConfig = () => {
  if (process.env.DATABASE_URL) {
    return {
      dialect: 'postgres',
      use_env_variable: 'DATABASE_URL',
    };
  }

  return {
    dialect: 'postgres',
    database: process.env.DATABASE_NAME,
    username: process.env.DATABASE_USERNAME,
    password: process.env.DATABASE_PASSWORD,
    port: process.env.DATABASE_PORT,
    host: process.env.DATABASE_HOST,
  };
};

const getSqliteConfig = (storage) => ({
  dialect: 'sqlite',
  storage,
});

module.exports = {
  development: hasPostgresConfig
    ? getPostgresConfig()
    : getSqliteConfig('./database.sqlite'),
  production: getPostgresConfig(),
  test: hasPostgresConfig
    ? getPostgresConfig()
    : getSqliteConfig('./database.test.sqlite'),
};
