<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="${(empty sessionScope.lang) ? 'fr': sessionScope.lang}"/>

<fmt:setBundle basename="messages"/>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-type" content="text/html; charset=utf-8">
        <title>${appTitle} - <fmt:message key="label.admin_panel"/></title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="/style.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
        <link rel="icon" type="image/png" href="${appFavicon}">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </head>
    <header>
        <!-- NAVBAR -->
        <nav class="navbar navbar-expand bg-light">
            <div class="container-fluid">
                <span class="navbar-brand">
                    <img src="${appFavicon}" width="32px">
                    ${appTitle}
                </span>
                
                <div class="collapse navbar-collapse" id="navbarContent">
                    <ul class="navbar-nav me-auto">
                        <li class="nav-item">
                            <a class="nav-link" href="planning"><fmt:message key="label.planning"/></a>
                        </li>

                        <li class="nav-item">
                            <a class="nav-link" href="compte"><fmt:message key="label.account"/></a>
                        </li>

                        <li class="nav-item">
                            <a class="nav-link" href="panel_admin"><fmt:message key="label.admin_panel"/></a>
                        </li>
                    </ul>

                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item">
                            <form:form action="/logout" method="post">
                                <c:if test="${_csrf != null}">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                </c:if>
                                <button class="btn btn-outline-danger"><fmt:message key="label.logout"/></button>
                            </form:form>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>
    </header>
    <body>
        <!-- CONTENEUR GLOBAL -->
        <div class="container my-4 p-4 shadow-lg rounded-4 bg-light">

            <!-- TITRE -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="fw-bold text-primary">
                <i class="bi bi-person-circle"></i> <fmt:message key="label.registered_users"/>
                </h2>
            </div>

            <!-- JOUR -->
            <div id="day_planning" class="text-center">

                <span class="d-flex justify-content-between mb-4">
                    <h3 class="fw-semibold"><fmt:message key="label.slots_of"/> <span class="text-success">${formattedDate}</span> <fmt:message key="label.from"/> <span class="text-success">${formattedTimeStart}</span> <fmt:message key="label.to"/> <span class="text-success">${formattedTimeEnd}</span></h3>
                </span>

                <!-- USERS -->
                <div class="row g-4 justify-content-center">
                    <c:forEach items="${users}" var="user">  
                        <div class="col-md-5 col-lg-4">
                            <div class="card border-0 shadow-sm rounded-4 h-100">
                                
                                <div class="card-body d-flex align-items-center gap-3 p-4">

                                    <!-- Avatar -->
                                    <c:choose>
                                        <c:when test="${not empty user.img_path}">
                                            <img src="${user.img_path}" class="rounded-circle border border-2 shadow-sm" style="width: 80px; height: 80px; object-fit: cover;">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="rounded-circle bg-primary text-white d-flex justify-content-center align-items-center" 
                                                style="width:80px; height:80px; font-size:1.4rem; font-weight:600;">
                                                ${fn:substring(user.firstname, 0, 1)}${fn:substring(user.lastname, 0, 1)}
                                            </div>
                                        </c:otherwise>
                                    </c:choose>

                                    <!-- User Info -->
                                    <div class="text-secondary text-start">
                                        <h5 class="mb-1 text-dark">${user.firstname} ${user.lastname}</h5>
                                        <p class="mb-1"><i class="bi bi-person"></i> ${user.login}</p>
                                        <p class="mb-0"><i class="bi bi-envelope"></i> ${user.email}</p>
                                        <form:form action="documents" method="get" class="d-inline">
                                            <input type="hidden" name="idSlot" value="${idSlot}">
                                            <input type="hidden" name="login" value="${user.login}">
                                            <input type="hidden" name="lastPage" value="${lastPage}">
                                            <button class="btn btn-sm btn-primary me-2">
                                                <fmt:message key="label.documents"/>
                                            </button>
                                        </form:form>
                                    </div>

                                </div>

                            </div>
                        </div>
                    </c:forEach>
                </div>

                <a class="btn btn-outline-secondary mt-4 mb-5" href="/panel_admin?date=${date}">
                    <i id="goBack" class="bi bi-arrow-left"></i> 
                    <fmt:message key="label.back_to_admin_panel"/>
                </a>
            </div>
        </div>
    </body>

    <footer class="fixed-bottom bg-light">
        <div class="d-flex justify-content-between border-top p-3">
            <span>${appTitle} &copy;</span>
            <span>Florine Lefebvre & Charlie Darques</span>
        </div>
    </footer>
</html>
