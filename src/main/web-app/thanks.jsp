<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <title>Murach's Java Servlets and JSP</title>
    <link rel="stylesheet" href="styles/style.css" type="text/css"/>

</head>

<body>
    <h1>Thanks for joining our email list</h1>

    <p>Here is the information that you entered:</p>

    <label>Email:</label>
    <span>${user.email}</span><br>
    <label>First Name:</label>
    <span>${user.firstName}</span><br>
    <label>Last Name:</label>
    <span>${user.lastName}</span><br>

    <h1>Survey</h1>
    <label>How did you hear about us?:</label>
    <span>${survey.heardFrom}</span><br>
    <label>Announcements preferences:</label>
    <span>${survey.wantsUpdates}</span><br>
    <label>&nbsp;</label>
    <span>${survey.emailOK}</span><br>
    <label>Please contact me by:</label>
    <span>${survey.contactMethod}</span><br>

    <p>To enter another email address, click on the Back
        button in your browser or the Return button shown
        below.</p>

    <form action="emailList" method="get">
        <input type="hidden" name="action" value="join">
        <input type="submit" value="Return">
    </form>
</body>
</html>