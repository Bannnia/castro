package database

import (
	"fmt"

	// Let sqlx know about MySQL
	_ "github.com/jinzhu/gorm/dialects/mysql"
	"github.com/jmoiron/sqlx"
)

// DB holds the main database handle
var DB *sqlx.DB

// Open creates a new connection to a MySQL database with the given credentials
func Open(username, password, host, port, db, params string) (*sqlx.DB, error) {
	// Connect to the given database
	databaseHandle, err := sqlx.Connect("mysql", fmt.Sprintf(
		"%v:%v@(%v:%v)/%v?charset=utf8&parseTime=True&loc=Local"+params,
		username,
		password,
		host,
		port,
		db,
	))

	// Return database handler
	return databaseHandle, err
}
