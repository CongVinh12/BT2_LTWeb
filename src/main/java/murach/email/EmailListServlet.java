package murach.email;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import murach.business.User;
import murach.business.Survey;

@WebServlet("/emailList")
public class EmailListServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String url = "/index.html";

        String action = request.getParameter("action");
        if (action == null) {
            action = "join";
        }

        if (action.equals("join")) {
            url = "/index.html";
        }
        else if (action.equals("add")) {
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String dateOfBirth = request.getParameter("dateofbirth");

            User user = new User(firstName, lastName, email);
            request.setAttribute("user", user);
            request.setAttribute("dateOfBirth", dateOfBirth);

            String heardFrom = request.getParameter("contactVia");
            if (heardFrom == null) {
                heardFrom = "Not specified";
            }

            String check1 = request.getParameter("check1");
            String wantsUpdates = (check1 != null) ? "Yes" : "No";

            String check2 = request.getParameter("check2");
            String emailOK = (check2 != null) ? "Yes" : "No";

            String contactMethod = request.getParameter("contactMethod");
            if (contactMethod == null) {
                contactMethod = "Email";
            }

            Survey survey = new Survey(heardFrom, wantsUpdates, emailOK, contactMethod);
            request.setAttribute("survey", survey);

            url = "/thanks.jsp";
        }

        getServletContext()
                .getRequestDispatcher(url)
                .forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}