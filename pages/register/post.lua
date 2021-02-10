function post()
    if session:isLogged() then
        http:redirect("/")
        return
    end

    if app.Captcha.Enabled then
        if not captcha:verify(http.postValues["g-recaptcha-response"]) then
            session:setFlash("validationError", "Invalid captcha answer")
            http:redirect("/subtopic/register")
            return
        end
    end

    if db:singleQuery("SELECT name FROM accounts WHERE email = ?", http.postValues.email) ~= nil then
        session:setFlash("validationError", "Email already in use by another user")
        http:redirect("/subtopic/register")
        return
    end

    if db:singleQuery("SELECT name FROM accounts WHERE name = ?", http.postValues["account-name"]) ~= nil then
        session:setFlash("validationError", "Account name already in use by another user")
        http:redirect("/subtopic/register")
        return
    end

    if not validator:validate("IsEmail", http.postValues.email) then
        session:setFlash("validationError", "Invalid email format")
        http:redirect("/subtopic/register")
        return
    end

    if not validator:validate("IsAlphanumeric", http.postValues["account-name"]) or validator:validate("IsNull", http.postValues["account-name"]) then
        session:setFlash("validationError", "Invalid account name format. Only letters (A-Z) and numbers (0-9) allowed")
        http:redirect("/subtopic/register")
        return
    end

    if string.len(http.postValues["account-name"]) > 16 or string.len(http.postValues["account-name"]) < 4 then
        session:setFlash("validationError", "Invalid account name length. Account name must be 4 - 16 characters long")
        http:redirect("/subtopic/register")
        return
    end

    if string.len(http.postValues["password"]) > 32 or string.len(http.postValues["password"]) < 8 then
        session:setFlash("validationError", "Invalid password length. Password must be 8 - 32 characters long")
        http:redirect("/subtopic/register")
        return
    end

    local id = db:execute(
        "INSERT INTO accounts (name, password, premium_ends_at, email, creation) VALUES (?, ?, ?, ?, ?)",
        http.postValues["account-name"],
        crypto:sha1(http.postValues["password"]),
        os.time() + (10 * 86400),
        http.postValues["email"],
        os.time()
    )

    db:execute("INSERT INTO castro_accounts (account_id) VALUES (?)", id)
    session:setFlash("success", "Account created. You can now sign in")
    http:redirect("/subtopic/login")
end