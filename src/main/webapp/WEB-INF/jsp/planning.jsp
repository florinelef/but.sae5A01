<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.time.LocalDate"%>
<%@ page import="java.time.Month"%>
<%@ page import="java.time.format.TextStyle"%>
<%@ page import="java.util.Locale"%>
<%@ page import="java.time.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<fmt:setLocale value="${(empty sessionScope.lang) ? 'fr': sessionScope.lang}"/>
<fmt:setBundle basename="messages"/>

<!DOCTYPE html>
<html lang="${sessionScope.lang}">
    <head>
        <meta http-equiv="Content-type" content="text/html; charset=utf-8">
        <title>${appTitle} - <fmt:message key="label.planning"/></title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="/style.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
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

                    <c:if test="${role == 'admin'}">
                        <li class="nav-item">
                            <a class="nav-link" href="panel_admin"><fmt:message key="label.admin_panel"/></a>
                        </li>
                    </c:if>
                    </ul>

                    <ul class="navbar-nav ms-auto">

                        <li class="me-3"> 
                            <div class="dropdown">
                            <button class="btn btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <fmt:message key="label.language"/>
                            </button>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="changeLanguage?lang=fr&origin=planning"><fmt:message key="label.french"/></a></li>
                                <li><a class="dropdown-item" href="changeLanguage?lang=en&origin=planning"><fmt:message key="label.english"/></a></li>
                                <li><a class="dropdown-item" href="changeLanguage?lang=es&origin=planning"><fmt:message key="label.spanish"/></a></li>
                            </ul>
                            </div>
                        </li>

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

        <div id="planning" class="container my-4 p-4 shadow-lg rounded-4 bg-light">
            <!-- TITRE -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="fw-bold text-primary">
                    <fmt:message key="label.monthly_planning"/>
                </h2>
            </div>

            <h1 class="text-center">${monthString} ${viewYear}</h1>

            <div class="container-sm text-center mt-4 limited-calendar">
                <div class="row fw-bold">
                    <div class="col"><fmt:message key="label.monday"/></div>
                    <div class="col"><fmt:message key="label.tuesday"/></div>
                    <div class="col"><fmt:message key="label.wednesday"/></div>
                    <div class="col"><fmt:message key="label.thursday"/></div>
                    <div class="col"><fmt:message key="label.friday"/></div>
                    <div class="col"><fmt:message key="label.saturday"/></div>
                    <div class="col"><fmt:message key="label.sunday"/></div>
                </div>

                <c:forEach var="week" begin="1" end="6">
                <div class="row mt-3">
                    <c:forEach var="day" begin="1" end="7">
                    <div class="col">
                    <!-- calcul du numéro de jour du mois -->
                        <c:set var="dayNumber"
                            value="${((week - 1) * 7 + day) - (dayOfFirstOfMonth - 1)}" />

                        <!-- afficher seulement si dans la plage du mois -->
                        <c:if test="${not (week == 1 and day < dayOfFirstOfMonth) and dayNumber <= lengthOfMonth}">

                            <!-- détection du jour courant -->
                            <c:set var="isToday"
                                value="${viewMonth == currentDate.monthValue 
                                        and viewYear == currentDate.year 
                                        and dayNumber == currentDate.dayOfMonth}" />

                            <!-- verif si jour de fermeture -->
                            <c:set var="isClosed" value="true" />
                            <c:forEach var="d" items="${appOpenDays}">
                                <c:if test="${d.value == day}">
                                    <c:set var="isClosed" value="false"/>
                                </c:if>
                            </c:forEach>

                            <%-- verif si jour pas réservable (avant jour courant) --%>
                            <c:if test="${viewYear < currentDate.year}">
                                <c:set var="isClosed" value="true" />
                            </c:if>

                            <c:if test="${viewMonth < currentDate.monthValue 
                                        and viewYear == currentDate.year}">
                                <c:set var="isClosed" value="true" />
                            </c:if>

                            <c:if test="${viewMonth == currentDate.monthValue 
                                        and viewYear == currentDate.year 
                                        and dayNumber < currentDate.dayOfMonth}">
                                <c:set var="isClosed" value="true" />
                            </c:if>


                            <!-- construction de la date YYYY-MM-DD -->
                            <%-- lt = less than => si viewMonth < 10 alors on ajoute 0 devant sinon on laisse, idem pour le jour --%>
                            <c:set var="dateAsString"
                                value="${viewYear}-${viewMonth lt 10 ? '0' : ''}${viewMonth}-${dayNumber lt 10 ? '0' : ''}${dayNumber}" />

                            <%-- bouton actif ou non si jour de fermeture --%>
                            <c:if test="${!isClosed}">
                                <a class="btn ${isToday ? 'btn-outline-primary' : 'btn-outline-secondary'} btn-square mb-2 w-100"
                                href="day_planning?date=${dateAsString}">
                                    ${dayNumber}
                                </a>
                            </c:if>
                            <c:if test="${isClosed}">
                                <span class="btn btn-secondary btn-square mb-2 w-100">
                                    ${dayNumber}
                                </span>
                            </c:if>
                        </c:if>
                    </div>
                    </c:forEach>
                    </div>
                </c:forEach>
            </div>
            
            <div class="d-flex justify-content-center align-items-center p-3 mt-4">
                <a href="?month=${previousMonth}&year=${previousYear}" class="btn btn-secondary me-4"><i class="bi bi-arrow-left-circle-fill"></i> ${previousMonthString} ${previousYear}</a>
                <a href="?month=${nextMonth}&year=${nextYear}" class="btn btn-secondary">${nextMonthString} ${nextYear} <i class="bi bi-arrow-right-circle-fill"></i></a>
            </div>
        </div>

        <footer class="fixed-bottom bg-light">
            <div class="d-flex justify-content-between border-top p-3">
                <span>${appTitle} &copy;</span>
                <span>Florine Lefebvre & Charlie Darques</span>
            </div>
        </footer>
    </body>
</html>
