
json.hyper do
  json.statusCode  200
  json.errorCode  0
  json.version 1.0
  json.href_delete "https://api.epublishing.com/v1/users/delete/#{@user.user_token.to_s}"
  json.doc "https://api.epublishing.com/"
end

json.data do
  json.id               @user.id.to_s
  json.email            @user.email.to_s
  json.honorificPrefix  @user.prefix.to_s
  json.givenName        @user.first.to_s
  json.additionalName   @user.middle.to_s
  json.familyName       @user.last.to_s
  json.honorificSuffix  @user.suffix.to_s
  json.address do
    json.streetAddress   "#{@user.address1.to_s}  #{@user.address2.to_s}"
    json.addressLocality @user.city.to_s
    json.addressRegion   @user.state.to_s
    json.country         @user.country.to_s
    json.postalCode      @user.postal_code.to_s
  end
  json.internalNotes @user.notes.to_s
  json.worksFor do
    json.legalName     @user.company.to_s
    json.telephone     @user.work_phone.to_s
  end
  json.telephone    @user.home_phone.to_s
  json.cellNumber   @user.cell_phone.to_s
  json.faxNumber    @user.fax.to_s
  json.UID          @user.user_token.to_s
  json.legacy_id    @user.legacy_id.to_s
end

