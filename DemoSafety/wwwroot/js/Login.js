$(document).ready(function () {
    let emptymsg = '*This field is required*';
    var emailRegEx = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    $('select').on('blur', function () {
        var $this = $(this);
        var id = $this.attr('id');
        var $errElement = $('#' + id + 'err');
        if ($this.find(':selected').val() == '') {
            $errElement.text('Select ' + $this.attr('id')).show();
        }
    }).change(function () {
        var $this = $(this);
        var id = $this.attr('id');
        var $errElement = $('#' + id + 'err');
        if ($this.find(':selected').val() != '') {
            $errElement.empty();
        }
    });
    $('#log-user').blur(function () {
        $('#log-usererr').empty();
        if ($(this).val() == '') {
            $('#log-usererr').html(emptymsg);
        }
        else if (!(emailRegEx.test($(this).val()))) {
            $('#log-usererr').html('*Invalid user credential*');
        }
    });
    $('#log-pass').blur(function () {
        $('#log-passerr').empty();
        if ($('#log-pass').val() == '') {
            $('#log-passerr').text(emptymsg);
        }
        else if (!/^[A-Za-z\d@.#$!%*?&]{8,15}$/.test($('#log-pass').val())) {
            $('#log-passerr').append('*Invalid Password*');
        }
    });
    $('#loginBtn').click(function () {
        if ($('#log-user').val() == "") {
            $('#log-usererr').text(emptymsg);
        }
        if ($('#log-pass').val() == "") {
            $('#log-passerr').text(emptymsg);
        }
        if ($('#Organization').find(':selected').val() == "") {
            $('#Organizationerr').text(emptymsg);
        }
        if ($('small:lt(3)').text() == '') {
            var formData = {
                email: $('#log-user').val(),
                password: $('#log-pass').val(),
                org: $('#Organization').val()
            };
            $.ajax({
                url: 'https://localhost:7164/api/Login',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(formData),
                success: function (response) {
                    $('#liveToast .toast-body').text(response.message);
                    $('#liveToast').removeClass(' toast-warning toast-danger').addClass('toast-success');
                    $('.toast').toast('show');
                    document.cookie = "email=" + formData.email + "; path=/";
                    document.cookie = "password=" + formData.password + "; path=/";
                    document.cookie = "role=" + response.role + "; path=/";
                    document.cookie = "userId=" + response.userId + "; path=/";
                    setTimeout(function () {
                        $('#login-form').trigger('reset');
                        if (response.role == "Principal") {
                            window.location.href = '/principal';
                        }
                        else if (response.role == "Admin") {
                            window.location.href = '/admin';
                        }
                    }, 1000);
                },
                error: function (xhr, status, error) {
                    var errorMessage = 'An error occurred while processing your request.';
                    if (xhr.status === 401) {
                        errorMessage = xhr.responseJSON.message;
                        $('#liveToast').removeClass('toast-success toast-danger').addClass('toast-warning');
                    } else if (xhr.status === 404) {
                        errorMessage = xhr.responseJSON.message;
                        $('#liveToast').removeClass('toast-success toast-warning').addClass('toast-danger');
                    } else {
                        $('#liveToast').removeClass('toast-success toast-warning').addClass('toast-danger');
                    }
                    $('#liveToast .toast-body').text(errorMessage);
                    $('.toast').toast('show');
                }
            });
        }
    });
    $("#toggle-btn").click(function () {
        var x = $("#log-pass");
        var y = $("i");
        x.attr("type", x.attr("type") === "password" ? "text" : "password");
        y.toggleClass("bi-eye bi-eye-slash");
    });
});