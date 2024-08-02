CREATE TABLE bms_company(
    id         BIGSERIAL PRIMARY KEY,
    name       TEXT,
    address    TEXT,
    phone      TEXT,
    created_at DATE,
    expiration DATE,
    status     BOOLEAN
);

CREATE TABLE bms_office(
    id         BIGSERIAL PRIMARY KEY,
    company_id BIGINT,
    name       TEXT,
    address    TEXT,
    code       TEXT,
    phone      TEXT,
    note       TEXT,
    CONSTRAINT fk_company_for_office
        FOREIGN KEY (company_id)
        REFERENCES public.bms_company(id)
);

CREATE TABLE bms_router(
    id         BIGSERIAL PRIMARY KEY,
    company_id BIGINT,
    name       TEXT,
    short_name TEXT,
    price      FLOAT8,
    note       TEXT,
    CONSTRAINT fk_company_for_router
        FOREIGN KEY (company_id)
        REFERENCES public.bms_company(id)
);

CREATE TABLE bms_bus(
    id            BIGSERIAL PRIMARY KEY,
    company_id    BIGINT,
    bus_number    TEXT,
    capacity      SMALLINT,
    created_at    DATE,
    license_plate TEXT,
    status        TEXT,
    CONSTRAINT fk_company_for_bus
        FOREIGN KEY (company_id)
        REFERENCES public.bms_company(id)
);

CREATE TABLE bms_vehicle(
    id            BIGSERIAL PRIMARY KEY,
    company_id    BIGINT,
    category      TEXT,
    brand         TEXT,
    license_plate TEXT,
    phone         TEXT,
    color         TEXT,
    note          TEXT,
    CONSTRAINT fk_company_for_vehicle
        FOREIGN KEY (company_id)
        REFERENCES public.bms_company(id)
); 

CREATE TABLE bms_user(
    id         BIGSERIAL PRIMARY KEY,
    company_id BIGINT,
    username   TEXT,
    password   TEXT,
    email      TEXT,
    name       TEXT,
    birthday   DATE,
    created_at DATE,
    gender     TEXT,
    phone      TEXT,
    role       TEXT,
    status     TEXT,
    CONSTRAINT fk_company_for_user
        FOREIGN KEY (company_id)
        REFERENCES public.bms_company(id)
);

CREATE TABLE bms_agent(
    id         BIGSERIAL PRIMARY KEY,
    company_id BIGINT,
    name       TEXT,
    phone      TEXT,
    email      TEXT,
    address    TEXT,
    discount   FLOAT8,
    district   TEXT,
    province   TEXT,
    ward       TEXT,
    created_at DATE,
    CONSTRAINT fk_company_for_agent
        FOREIGN KEY (company_id)
        REFERENCES public.bms_company(id)
);

CREATE TABLE bms_trip(
    id             BIGSERIAL PRIMARY KEY,
    company_id     BIGINT,
    chair_diagram  TEXT,
    day_departure  DATE,
    time_departure DATE,
    driver         FLOAT8,
    router         TEXT,
    vehicle        TEXT,
    note           TEXT,
    CONSTRAINT fk_company_for_trip
        FOREIGN KEY (company_id)
        REFERENCES public.bms_company(id)
);

CREATE TABLE bms_chargecost(
    id                BIGSERIAL PRIMARY KEY,
    trip_id           BIGINT,
    station           FLOAT8,
    station_meal      FLOAT8,
    daily_meal        FLOAT8,
    washing           FLOAT8,
    repairing         FLOAT8,
    driver_salary     FLOAT8,
    assistant_salary  FLOAT8,
    freight_collected FLOAT8,
    gas               FLOAT8,
    bus_station       FLOAT8,
    agent             FLOAT8,
    CONSTRAINT fk_trip_for_chargecost
        FOREIGN KEY (trip_id)
        REFERENCES public.bms_trip(id)
);

CREATE TABLE bms_goods(
    id              BIGSERIAL PRIMARY KEY,
    trip_id         BIGINT,
    user_id         BIGINT,
    name            TEXT,
    created_at      DATE,
    paid_ammount    FLOAT8,
    fee             FLOAT8,
    boarding_point  TEXT,
    dropping_point  TEXT,
    receiver_name   TEXT,
    receiver_phone  TEXT,
    return_method   TEXT,
    sender_name     TEXT,
    sender_phone    TEXT,
    shipping_method TEXT,
    total_amount    FLOAT8,
    note            TEXT,
    CONSTRAINT fk_trip_for_goods
        FOREIGN KEY (trip_id)
        REFERENCES public.bms_trip(id),
    CONSTRAINT fk_user_for_goods
        FOREIGN KEY (user_id)
        REFERENCES public.bms_user(id)
);

CREATE TABLE bms_ticket(
    id             BIGSERIAL PRIMARY KEY,
    trip_id        BIGINT,
    boarding_point TEXT,
    dropping_point TEXT,
    name           TEXT,
    seat_number    TEXT,
    price          FLOAT8,
    phone          TEXT,
    note           TEXT,
    CONSTRAINT fk_trip_for_ticket
        FOREIGN KEY (trip_id)
        REFERENCES public.bms_trip(id)
);
