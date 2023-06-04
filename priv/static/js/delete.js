// delete user 
$('#dt-basic-example tbody').on('click', '.js-dev_user', function() {
    var button = $(this);
    Swal.fire({
        title: 'Are you sure?',
        text: "You won't be able to revert this!",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: 'Yes, continue!'
    }).then((result) => {
        if (result.value) {
            $.ajax({
                url: '/Update/Dev/Use',
                type: 'delete',
                data: { id: button.attr("data-dev_user"), _csrf_token: $("#csrf").val() },
                success: function(result) {
                    if (result.data) {
                        Swal.fire(
                            'Success',
                            'User deleted successfuly!',
                            'success'
                        )
                        location.reload(true);
                    } else {
                        Swal.fire(
                            'Success',
                            'User has been Deactivated successfuly!',
                            'success'
                        )
                        location.reload(true);
                    }
                },
                error: function(request, msg, error) {
                    Swal.fire(
                        'Oops..',
                        'Something went wrong! try again',
                        'error'
                    )
                }
            });
        } else if (
            /* Read more about handling dismissals below */
            result.dismiss === Swal.DismissReason.cancel
        ) {
            swal.fire(
                'Cancelled',
                'Operation not performed :)',
                'error'
            )
        }
    })

});