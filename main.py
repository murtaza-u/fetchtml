#!/usr/bin/env python3

from selenium import webdriver
import sys

if len(sys.argv) <= 1:
    print("missing url")
    sys.exit(1)

url = sys.argv[1]

options = webdriver.ChromeOptions()
options.add_argument("--headless=new")
driver = webdriver.Chrome(options=options)

driver.get(url)
print(driver.page_source)

driver.quit()
