create table stock_symbol (
  symbol varchar PRIMARY KEY,
  description varchar,
  exchange varchar
);

create table stock_ticker (
  symbol varchar,
  tick_date varchar,
  open decimal,
  high decimal,
  low decimal,
  close decimal,
  volume bigint,
  primary key(symbol, tick_date)
);

create table stock_ticker_by_exchange (
  exchange varchar,
  symbol varchar,
  description varchar,
  tick_date varchar,
  close decimal,
  primary key (exchange, symbol, tick_date)
);



create table stock_ticker_by_exchange_date (
  exchange varchar,
  symbol varchar,
  description varchar,
  tick_date varchar,
  close decimal,
  primary key ((exchange, tick_date), symbol)
);
