package main

import (
	"os"
	"time"

	"github.com/BurntSushi/toml"
	"github.com/dchest/uniuri"
	"github.com/raggaer/castro/app/util"
)

func isInstalled() bool {
	// Check if file exists
	_, err := os.Stat("config.toml")

	return err == nil
}

func createConfigFile(name string) error {
	// Create configuration file handle
	configFile, err := os.Create(name)
	if err != nil {
		return err
	}

	// Close file handle
	defer configFile.Close()

	// Encode the given configuration struct into the file
	return toml.NewEncoder(configFile).Encode(util.Configuration{
		Mode:     "dev",
		Port:     8080,
		URL:      "localhost",
		Datapack: "/",
		Secret:   uniuri.NewLen(35),
		Captcha: util.CaptchaConfig{
			Enabled: false,
		},
		Cookies: util.CookieConfig{
			Name:   "castro",
			MaxAge: 1000000,
		},
		Cache: util.CacheConfig{
			Default: time.Minute * 5,
			Purge:   time.Minute,
		},
		SSL: util.SSLConfig{
			Enabled: false,
		},
		RateLimit: util.RateLimiterConfig{
			Number: 100,
			Time:   time.Minute,
		},
		Custom: make(map[string]interface{}),
	})
}
