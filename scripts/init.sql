/* ---- Creating Extension needed for uuid datatypes and uuid operations ---- */
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
/* ---- Initializing all tables ---- */

CREATE TABLE public.Image (
    ID uuid PRIMARY KEY NOT NULL,
    PathString Varchar(255) NOT NULL,
    FileName Varchar(255) NOT NULL,
    IsMainImage Boolean DEFAULT(false),
    CreatedDateTime timestamp NOT NULL,
    IsDeleted Boolean DEFAULT(false),
    ModifiedDateTime timestamp
);
CREATE TABLE public.AdvertisementImage (
    AdvertisingID uuid NOT NULL,
    ImageID uuid NOT NULL,
    CreatedDateTime timestamp NOT NULL,
    IsDeleted Boolean DEFAULT(false),
    ModifiedDateTime timestamp,
    PRIMARY KEY(AdvertisingID, ImageID)
);

CREATE TABLE public.Institution (
    ID uuid PRIMARY KEY NOT NULL,
    Name Varchar(50) NOT NULL,
    CreatedDateTime timestamp NOT NULL,
    IsDeleted Boolean DEFAULT(false),
    ModifiedDateTime timestamp
);

CREATE TABLE public.User (
    ID uuid PRIMARY KEY NOT NULL,
    Username Varchar(50) NOT NULL,
    Password Varchar(50) NOT NULL,
    Name Varchar(64) NOT NULL,
    Surname Varchar(64) NOT NULL,
    Email Varchar(50) NOT NULL,
    InstitutionID uuid NOT NULL,
    CONSTRAINT userinstitutionfkey FOREIGN KEY (InstitutionID)
        REFERENCES public.Institution (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    CreatedDateTime timestamp NOT NULL,
    AdvertisementsRemaining DEC(5,0) DEFAULT(0),
    IsDeleted Boolean DEFAULT(false),
    ModifiedDateTime timestamp
);

CREATE TABLE public.UserValidation (
    ID uuid PRIMARY KEY NOT NULL,
    UserID uuid NOT NULL,
    CONSTRAINT uservalidationuserfkey FOREIGN KEY (UserID)
        REFERENCES public.User (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    PhoneNumber Varchar(15) NOT NULL,
    ValidationStatus Varchar(50) DEFAULT('OTP Sent'),
    OTP Varchar(10) NOT NULL,
    SentDate timestamp NOT NULL,
    CreatedDateTime timestamp NOT NULL,
    IsDeleted Boolean DEFAULT(false),
    ModifiedDateTime timestamp
);


CREATE TABLE public.Advertisement (
    ID uuid PRIMARY KEY NOT NULL,
    UserID uuid NOT NULL,
    IsSelling Boolean DEFAULT(true),
    CONSTRAINT adertisementuserfkey FOREIGN KEY (UserID)
        REFERENCES public.User (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    AdvertisementType Varchar(3) NOT NULL,
    EntityID uuid NOT NULL,
    Price DEC(15,2) NOT NULL,
    Description Varchar(255) NOT NULL,
    InstitutionID uuid NOT NULL,
    CONSTRAINT advertisementinstitutionfkey FOREIGN KEY (InstitutionID)
        REFERENCES public.Institution (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    CreatedDateTime timestamp NOT NULL,
    IsDeleted Boolean DEFAULT(false),
    ModifiedDateTime timestamp
);

CREATE TABLE public.Rating (
    ID uuid PRIMARY KEY NOT NULL,
    AdvertisementID uuid NOT NULL,
    SellerID uuid NOT NULL,
    BuyerID uuid NOT NULL,
    CONSTRAINT ratingsellerfkey FOREIGN KEY (SellerID)
        REFERENCES public.User (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT ratingbuyerfkey FOREIGN KEY (BuyerID)
        REFERENCES public.User (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT ratingadvertisementfkey FOREIGN KEY (AdvertisementID)
        REFERENCES public.Advertisement (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    BuyerRating DEC(15,2),
    SellerRating DEC(15,2),
    BuyerComments Varchar(255),
    SellerComments Varchar(255),
    CreatedDateTime timestamp NOT NULL,
    IsDeleted Boolean DEFAULT(false),
    ModifiedDateTime timestamp
);
CREATE TABLE public.AdvertisementType (
    Code Varchar(3) NOT NULL,
    Name Varchar(350) NOT NULL,
    Description Varchar(255) NOT NULL,
    CreatedDateTime timestamp NOT NULL,
    IsDeleted Boolean DEFAULT(false),
    ModifiedDateTime timestamp
);



CREATE TABLE public.Faculty (
    ID uuid PRIMARY KEY NOT NULL,
    InstitutionID uuid NOT NULL,
    CONSTRAINT facultyinstitutionfkey FOREIGN KEY (InstitutionID)
        REFERENCES public.Institution (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    Name Varchar(50) NOT NULL,
    CreatedDateTime timestamp NOT NULL,
    IsDeleted Boolean DEFAULT(false),
    ModifiedDateTime timestamp
);
CREATE TABLE public.Module (
    ID uuid PRIMARY KEY NOT NULL,
    FacultyID uuid NOT NULL,
    CONSTRAINT modulefacultyfkey FOREIGN KEY (FacultyID)
        REFERENCES public.Faculty (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    Name Varchar(50) NOT NULL,
    ModuleCode Varchar(50) NOT NULL,
    CreatedDateTime timestamp NOT NULL,
    IsDeleted Boolean DEFAULT(false),
    ModifiedDateTime timestamp
);
CREATE TABLE public.Notes (
    ID uuid PRIMARY KEY NOT NULL,
    ModuleID uuid NOT NULL,
    CONSTRAINT notesmodulefkey FOREIGN KEY (ModuleID)
        REFERENCES public.Module (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    CreatedDateTime timestamp NOT NULL,
    IsDeleted Boolean DEFAULT(false),
    ModifiedDateTime timestamp
);
CREATE TABLE public.Textbook (
    ID uuid PRIMARY KEY NOT NULL,
    ModuleID uuid NOT NULL,
    CONSTRAINT textbookmodulefkey FOREIGN KEY (ModuleID)
        REFERENCES public.Module (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    Name Varchar(255) NOT NULL,
    Edition Varchar(30),
    Quality Varchar(255) NOT NULL,
    Author Varchar(255) NOT NULL,
    CreatedDateTime timestamp NOT NULL,
    IsDeleted Boolean DEFAULT(false),
    ModifiedDateTime timestamp
);

CREATE TABLE public.Tutor (
    ID uuid PRIMARY KEY NOT NULL,
    Subject Varchar(50) NOT NULL,
    YearCompleted Varchar(4) NOT NULL,
    ModuleID uuid NOT NULL,
    CONSTRAINT tutormodulefkey FOREIGN KEY (ModuleID)
        REFERENCES public.Module (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    Venue Varchar(100) NOT NULL,
    NotesIncluded Boolean NOT NULL,
    Terms Varchar(100) NOT NULL,
    CreatedDateTime timestamp NOT NULL,
    IsDeleted Boolean DEFAULT(false),
    ModifiedDateTime timestamp
);

CREATE TABLE public.AccomodationType (
    Code Varchar(3) PRIMARY KEY NOT NULL,
    Name Varchar(50) NOT NULL,
    Description Varchar(255) NOT NULL,
    CreatedDateTime timestamp NOT NULL,
    IsDeleted Boolean DEFAULT(false),
    ModifiedDateTime timestamp
);

CREATE TABLE public.Accomodation (
    ID uuid PRIMARY KEY NOT NULL,
    AccomodationTypeCode varchar(3) NOT NULL,
    CONSTRAINT accomodationaccomodationtypefkey FOREIGN KEY (AccomodationTypeCode)
        REFERENCES public.AccomodationType (Code) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    InstitutionID uuid NOT NULL,
    CONSTRAINT accomodationinstitutionfkey FOREIGN KEY (InstitutionID)
        REFERENCES public.Institution (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    Location Varchar(255) NOT NULL,
    DistanceToCampus numeric NOT NULL,
    CreatedDateTime timestamp NOT NULL,
    IsDeleted Boolean DEFAULT(false),
    ModifiedDateTime timestamp
);
CREATE TABLE public.Feature (
    Code VARCHAR(3) PRIMARY KEY NOT NULL,
    Name Varchar(100) NOT NULL,
    Description Varchar(255) NOT NULL,
    CreatedDateTime timestamp NOT NULL,
    IsDeleted Boolean DEFAULT(false),
    ModifiedDateTime timestamp
);

CREATE TABLE public.AccomodationFeature (
    AccomodationID uuid NOT NULL,
    FeatureID uuid NOT NULL,
    CreatedDateTime timestamp NOT NULL,
    IsDeleted Boolean DEFAULT(false),
    ModifiedDateTime timestamp,
    PRIMARY KEY(AccomodationID, FeatureID)
);
CREATE TABLE public.EntityCode (
    Code Varchar(3) PRIMARY KEY NOT NULL,
    Name Varchar(25) NOT NULL,
    Description Varchar(255) NOT NULL,
    CreatedDateTime timestamp NOT NULL,
    IsDeleted Boolean DEFAULT(false),
    ModifiedDateTime timestamp
);
CREATE TABLE public.EventCode (
    Code Varchar(3) PRIMARY KEY NOT NULL,
    Name Varchar(25) NOT NULL,
    Description Varchar(255) NOT NULL,
    CreatedDateTime timestamp NOT NULL,
    IsDeleted Boolean DEFAULT(false),
    ModifiedDateTime timestamp
);
CREATE TABLE public.Event (
    ID uuid PRIMARY KEY NOT NULL,
    EventCode varchar(3) NOT NULL,
    EntityCode varchar(3) NOT NULL,
    CONSTRAINT eventeventcodefkey FOREIGN KEY (EventCode)
        REFERENCES public.EventCode (Code) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT evententitycodefkey FOREIGN KEY (EntityCode)
        REFERENCES public.EntityCode (Code) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,    
    EntityID uuid NOT NULL,
    CreatedDateTime timestamp NOT NULL,
    IsDeleted Boolean DEFAULT(false),
    ModifiedDateTime timestamp
);



/* ---- Create tables for Messaging ---- */
CREATE TABLE public.Chat (
    ID uuid PRIMARY KEY NOT NULL,
    SellerID uuid NOT NULL,
    BuyerID uuid NOT NULL,
    CONSTRAINT selleridfkey FOREIGN KEY (SellerID)
        REFERENCES public.User (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT buyeridfkey FOREIGN KEY (BuyerID)
        REFERENCES public.User (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    AdvertisementType Varchar(3),
    AdvertisementID uuid NOT NULL,
    CONSTRAINT chatadvertisementfkey FOREIGN KEY (AdvertisementID)
        REFERENCES public.Advertisement (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    IsRated Boolean DEFAULT(false),
    IsActive Boolean DEFAULT(false),
    CreatedDateTime timestamp NOT NULL,
    IsDeleted Boolean DEFAULT(false),
    ModifiedDateTime timestamp
);

CREATE TABLE public.Message (
    ID uuid PRIMARY KEY NOT NULL,
    ChatID uuid NOT NULL,
    CONSTRAINT chatidfkey FOREIGN KEY (ChatID)
        REFERENCES public.Chat (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    AuthorID uuid NOT NULL,
    CONSTRAINT authoruseridfkey FOREIGN KEY (AuthorID)
        REFERENCES public.User (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    Message Varchar(1000),
    MessageDate timestamp,
    IsRead Boolean DEFAULT(false),
    CreatedDateTime timestamp NOT NULL,
    IsDeleted Boolean DEFAULT(false),
    ModifiedDateTime timestamp
);


/*
----------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------FUNCTIONS---------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------
*/

/* ---- Creating all functions needed for CRUD functions to be used by the CRUD service ---- */

/* ---- Get all module codes that exist in the database function ---- */

CREATE OR REPLACE FUNCTION public.getmodulecodes(
	)
    RETURNS TABLE(modulecode character varying) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT m.modulecode
    FROM public.module m
    WHERE isdeleted = false;
END;
$BODY$;

/* ---- Register User Function ---- */
CREATE OR REPLACE FUNCTION public.registeruser(
	var_username character varying,
	var_password character varying,
	var_name character varying,
	var_surname character varying,
	var_email character varying,
	var_institutionname character varying,
	OUT res_created boolean,
	OUT ret_username character varying,
	OUT ret_user_id uuid,
	OUT ret_error character varying)
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
    userid uuid := uuid_generate_v4();
    var_institutionid uuid;
BEGIN
	IF EXISTS (SELECT 1 FROM public.user u WHERE u.username = var_username) THEN
		res_created := false;
		ret_username := '';
		ret_user_id := '00000000-0000-0000-0000-000000000000';
		ret_error := 'This Username Already Exists!';
			ELSE IF EXISTS (SELECT 1 FROM public.user u WHERE u.email = var_email) THEN
				res_created := false;
				ret_username := '';
				ret_user_id := '00000000-0000-0000-0000-000000000000';
				ret_error := 'This Email Already Exists!';
					ELSE
                        IF EXISTS (SELECT 1 FROM public.Institution i WHERE i.name = var_institutionname AND i.isdeleted = false) THEN
                           SELECT i.id
                           INTO var_institutionid 
                           FROM public.institution i  
                           WHERE i.name = var_institutionname AND i.isdeleted = false;
						INSERT INTO public.User(ID, Username, Password, Name, Surname, Email, InstitutionID, CreatedDateTime, IsDeleted, ModifiedDateTime)
    					VALUES (userid, var_username, var_password, var_name, var_surname, var_email,var_institutionid, CURRENT_TIMESTAMP , 'false', CURRENT_TIMESTAMP);
    					res_created := true;
    					ret_username := var_username;
    					ret_user_id := userid;
						ret_error := 'User Successfully Created!';
                        END IF;
    				END IF;
			END IF;
END;
$BODY$;

/* ---- Get Institutions Function ---- */
CREATE OR REPLACE FUNCTION public.getinstitutions(
	)
    RETURNS TABLE(modulecode character varying) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT i.name
    FROM public.institution i
    WHERE isdeleted = false;
END;
$BODY$;

/* ---- Get user on ID Function ---- */

CREATE OR REPLACE FUNCTION public.getuser(
	var_userid uuid,
	OUT ret_varid uuid,
	OUT ret_username character varying,
	OUT ret_name character varying,
	OUT ret_surname character varying,
	OUT ret_email character varying,
	OUT ret_institution character varying,
    OUT ret_adsremaining character varying,
	OUT ret_successget boolean)
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
IF EXISTS (SELECT 1 FROM public.User u WHERE u.id = var_userid AND u.isdeleted = false) THEN
	SELECT u.id, u.username, u.name, u.surname, u.email, i.name, u.advertisementsremaining
	INTO ret_varid, ret_username, ret_name, ret_surname, ret_email, ret_institution, ret_adsremaining
    FROM public.User u
    INNER JOIN public.Institution i 
    ON u.institutionid = i.id
    WHERE var_userid = u.id AND u.isdeleted = false;
	ret_successget = true;
	ELSE
        ret_varid = '00000000-0000-0000-0000-000000000000';
        ret_username = 'none';
		ret_name = 'none';
		ret_surname = 'none';
		ret_email = 'none';
        ret_institution = 'none';
        ret_adsremaining = 'none';
        ret_successget = false; 
    END IF;
END;
$BODY$;

/* ---- Update User details Function ---- */

CREATE OR REPLACE FUNCTION public.updateuser(
	var_userid uuid,
	var_username character varying,
	var_name character varying,
	var_surname character varying,
	var_email character varying,
	var_institutionname character varying,
	OUT res_updated boolean,
	OUT res_error character varying)
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
 var_institutionid uuid;
BEGIN
IF EXISTS (SELECT 1 FROM public.user u WHERE u.username = var_username AND u.id != var_userid) THEN
	res_updated := false;
	res_error := 'This Username Already Exists!';
		ELSE IF (SELECT 1 FROM public.user u WHERE u.email = var_email AND u.id != var_userid) THEN
			res_updated := false;
			res_error := 'This Email Already Exists!';
                ELSE IF (SELECT 1 FROM public.user u WHERE u.isdeleted = true AND u.id = var_userid) THEN
			    res_updated := false;
			    res_error := 'This User is deleted!';
				    ELSE
                     IF EXISTS (SELECT 1 FROM public.Institution i WHERE i.name = var_institutionname AND i.isdeleted = false) THEN
                           SELECT i.id
                           INTO var_institutionid 
                           FROM public.institution i  
                           WHERE i.name = var_institutionname AND i.isdeleted = false;
    				    UPDATE public.User
   				 	    SET username = var_username, name = var_name, surname = var_surname, email = var_email, institutionid= var_institutionid, modifieddatetime = CURRENT_TIMESTAMP
    				    WHERE var_userid = id;
    				    res_updated := true;
					    res_error := 'User Successfully Updated';
                        END IF;
				    END IF;
                END IF;
		END IF;
END;
$BODY$;

/* ---- Update Password for user Function ---- */
CREATE OR REPLACE FUNCTION public.updatepassword(
	var_userid uuid,
	var_oldpassword character varying,
	var_password character varying,
	OUT res_updated boolean,
	OUT res_error character varying)
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
BEGIN
IF EXISTS (SELECT 1 FROM public.user u WHERE u.isdeleted = true AND u.id = var_userid) THEN
	res_updated := false;
	res_error := 'This User is deleted!';
    ELSE IF EXISTS (SELECT 1 FROM public.user u WHERE u.isdeleted = false AND u.id = var_userid AND u.password != var_oldpassword) THEN
	         res_updated := false;
	         res_error := 'Your current password is incorrect';
	ElSE
        UPDATE public.User
   	    SET id = var_userid, password = var_password, modifieddatetime = CURRENT_TIMESTAMP 
        WHERE var_userid = id AND isdeleted = false;
        res_updated := true;
	    res_error := 'Password successfully updated';
		END IF;
    END IF;
END;
$BODY$;

/* ---- Delete User on ID Function ---- */

CREATE OR REPLACE FUNCTION public.deleteuser(
	var_userid uuid,
	OUT res_deleted boolean)
    RETURNS boolean
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    
AS $BODY$
DECLARE
BEGIN
    IF EXISTS (SELECT 1 FROM public.User u WHERE u.id = var_userid) THEN
        UPDATE public.User
        SET isdeleted = true 
        WHERE var_userid = id;
        res_deleted := true;
    ELSE
        res_deleted := false;
    END IF;
    
END;
$BODY$;

/* ---- Login User Function ---- */

CREATE OR REPLACE FUNCTION public.loginuser(
	var_username character varying,
	var_password character varying,
	OUT ret_userid uuid,
	OUT ret_username character varying,
	OUT ret_successlogin boolean,
	OUT ret_institution character varying)
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
IF EXISTS (SELECT 1 FROM public.User u WHERE u.username = var_username AND u.password = var_password) THEN
    SELECT u.id, u.username, i.name
    INTO ret_userid, ret_username, ret_institution
    FROM public.User u, public.Institution i
    WHERE  u.username = var_username AND u.password = var_password; 
    ret_successlogin = true;
    ELSE
        ret_userid = '00000000-0000-0000-0000-000000000000';
        ret_username = var_username;
        ret_successlogin = false;
		ret_institution = '00000000-0000-0000-0000-000000000000';
    END IF;
END;
$BODY$;

/* ---- Add new Advertisement Function ---- */

CREATE OR REPLACE FUNCTION public.addadvertisement(
	var_userid uuid,
	var_isselling boolean,
	var_advertisementtype character varying,
	var_entityid uuid,
	var_price double precision,
	var_description character varying,
	var_institution character varying,
	OUT res_advertisementposted boolean,
	OUT ret_id uuid,
	OUT ret_error character varying)
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
    var_institutionid uuid;
    id uuid := uuid_generate_v4();
BEGIN
    IF EXISTS (SELECT 1 FROM public.user u WHERE u.isdeleted = false AND u.id = var_userid AND u.advertisementsremaining = 0) THEN
	res_advertisementposted := false;
	ret_id := '00000000-0000-0000-0000-000000000000';
	ret_error := 'There are no advetisements remaining, please purchase more credits in order to post an advertisement';
    ELSE IF EXISTS (SELECT 1 FROM public.Institution i WHERE i.name = var_institution AND i.isdeleted = false) THEN
        SELECT i.id
        INTO var_institutionid 
        FROM public.institution i  
        WHERE i.name = var_institution AND i.isdeleted = false;
	INSERT INTO public.Advertisement(ID, UserID, IsSelling, AdvertisementType, EntityID, Price, Description, InstitutionID, CreatedDateTime, IsDeleted, ModifiedDateTime)
    VALUES (id, var_userid,var_isselling, var_advertisementtype, var_entityid, var_price, var_description, var_institutionid, CURRENT_TIMESTAMP , 'false', CURRENT_TIMESTAMP);
        res_advertisementposted := true;
        ret_id := id;
        ret_error := 'Advert Successfully Created!';
        UPDATE public.User u
		SET advertisementsremaining = advertisementsremaining - 1
		WHERE var_userid = u.id;
    ELSE 
        res_advertisementposted := false;
        ret_id := '00000000-0000-0000-0000-000000000000';
        ret_error := 'Advert could not be added due to an internal error!';
	    END IF;
    END IF;
END;
$BODY$;

/* ---- Add Textbook Function ---- */
/* TODO: Error handling for duplicates */
CREATE OR REPLACE FUNCTION public.addtextbook(
	var_modulecode character varying,
	var_name character varying,
	var_edition character varying,
	var_quality character varying,
	var_author character varying,
	OUT ret_success boolean,
	OUT ret_textbookid uuid,
    OUT ret_modulecode character varying,
    OUT ret_name character varying,
    OUT ret_edition character varying,
    OUT ret_quality character varying,
    OUT ret_author character varying)
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    
AS $BODY$
DECLARE
	id uuid := uuid_generate_v4();
	var_moduleid uuid;
BEGIN
IF EXISTS (SELECT 1 FROM public.Module m WHERE m.modulecode = var_modulecode AND m.isdeleted = false) THEN
    SELECT m.id
    INTO var_moduleid 
    FROM public.Module m  
    WHERE m.modulecode = var_modulecode AND m.isdeleted = false;
 		INSERT INTO public.Textbook(ID, ModuleID, Name, Edition, Quality, Author, CreatedDateTime, IsDeleted, ModifiedDateTime)
    	VALUES (id, var_moduleid, var_name, var_edition, var_quality, var_author, CURRENT_TIMESTAMP , 'false', CURRENT_TIMESTAMP);
		ret_success = true;
		ret_textbookid = id;
        ret_modulecode = var_modulecode;
        ret_name = var_name;
        ret_edition = var_edition;
        ret_quality = var_quality;
        ret_author = var_author;
	ELSE
		ret_success = false;
		ret_textbookid = '00000000-0000-0000-0000-000000000000';
        ret_modulecode = 'none';
        ret_name = 'none';
        ret_edition = 'none';
        ret_quality = 'none';
        ret_author = 'none';
	END IF;
END;
$BODY$;

/* ---- Add Tutor Function ---- */
/* TODO: Error handling for duplicates */
CREATE OR REPLACE FUNCTION public.addtutor(
    var_id uuid,
	var_modulecode character varying,
	var_subject character varying,
	var_yearcompleted character varying,
	var_venue character varying,
	var_notesincluded bool,
    var_terms character varying,
	OUT ret_success bool,
	OUT ret_tutorid uuid)
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    
AS $BODY$
DECLARE
    var_moduleid uuid;
BEGIN
IF EXISTS (SELECT 1 FROM public.Module m WHERE m.modulecode = var_modulecode AND m.isdeleted = false) THEN
    SELECT m.id
    INTO var_moduleid 
    FROM public.Module m  
    WHERE m.modulecode = var_modulecode AND m.isdeleted = false;
INSERT INTO public.Tutor(ID, Subject, YearCompleted, ModuleID, Venue, NotesIncluded, Terms, CreatedDateTime, IsDeleted, ModifiedDateTime)
    VALUES (var_id, var_subject, var_yearcompleted, var_moduleid, var_venue, var_notesincluded, var_terms, CURRENT_TIMESTAMP , 'false', CURRENT_TIMESTAMP);
	    ret_success = true;
	    ret_tutorid = var_id;
    ELSE
		ret_success = false;
		ret_tutorid = '00000000-0000-0000-0000-000000000000';
	END IF;
END;
$BODY$;

/* ---- Add Accomodation Function ---- */
/* TODO: Error handling for duplicates */
CREATE OR REPLACE FUNCTION public.addaccomodation(
    var_id uuid,
	var_accomodationTypeCode character varying,
	var_institutionname character varying,
	var_location character varying,
    var_distanceToCampus numeric,
	OUT ret_success bool,
	OUT ret_accomodationid uuid)
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    
AS $BODY$
DECLARE
    var_institutionid uuid;
BEGIN
IF EXISTS (SELECT 1 FROM public.Institution i WHERE i.name = var_institutionname AND i.isdeleted = false) THEN
    SELECT i.id
    INTO var_institutionid 
    FROM public.institution i  
    WHERE i.name = var_institutionname AND i.isdeleted = false;
INSERT INTO public.Accomodation(ID, AccomodationTypeCode, InstitutionID, Location, DistanceToCampus, CreatedDateTime, IsDeleted, ModifiedDateTime)
    VALUES (var_id, var_accomodationTypeCode, var_institutionid, var_location, var_distanceToCampus, CURRENT_TIMESTAMP , 'false', CURRENT_TIMESTAMP);
	ret_success = true;
	ret_accomodationid = var_id;
    ELSE
		ret_success = false;
		ret_accomodationid = '00000000-0000-0000-0000-000000000000';
	END IF;
END;
$BODY$;

/* ---- Add Notes Function ---- */
/* TODO: Error handling for duplicates */
CREATE OR REPLACE FUNCTION public.addnote(
	var_id uuid,
	var_modulecode character varying,
	OUT ret_success boolean,
	OUT ret_noteid uuid)
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
    var_moduleid uuid;
BEGIN
IF EXISTS (SELECT 1 FROM public.Module m WHERE m.modulecode = var_modulecode AND m.isdeleted = false) THEN
    SELECT m.id
    INTO var_moduleid 
    FROM public.Module m  
    WHERE m.modulecode = var_modulecode AND m.isdeleted = false;
INSERT INTO public.Notes(ID, ModuleID, CreatedDateTime, IsDeleted, ModifiedDateTime)
    VALUES (var_id, var_moduleid, CURRENT_TIMESTAMP , 'false', CURRENT_TIMESTAMP);
	ret_success = true;
	ret_noteid = var_id;
    ELSE
		ret_success = false;
		ret_noteid = '00000000-0000-0000-0000-000000000000';
	END IF;
END;
$BODY$;



/* ---- Get advertisement on ID Function ---- */
CREATE OR REPLACE FUNCTION public.getadvertisement(
	var_advertisementid uuid,
    OUT ret_varid uuid,
    OUT ret_userid uuid,
    OUT ret_isselling boolean,
    OUT ret_advertisementtype character varying,
    OUT ret_entityid uuid,
    OUT ret_price float,
    OUT ret_description character varying)
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE
AS $BODY$
BEGIN
IF EXISTS (SELECT 1 FROM public.Advertisement u WHERE u.id = var_advertisementid AND u.isdeleted = false) THEN
	SELECT u.id, u.userid, u.isselling, u.advertisementtype, u.entityid, u.price, u.description
    INTO ret_varid, ret_userid,ret_isselling, ret_advertisementtype, ret_entityid, ret_price, ret_description
    FROM public.Advertisement u
    WHERE var_advertisementid = u.id AND isdeleted = false;
    ELSE
        ret_varid = '00000000-0000-0000-0000-000000000000';
        ret_userid = '00000000-0000-0000-0000-000000000000';
        ret_isselling = false;
		ret_advertisementtype = 'none';
		ret_entityid = '00000000-0000-0000-0000-000000000000';
		ret_price = 0;
        ret_description = 'none'; 
    END IF;
END;
$BODY$;

/* ---- Update Advertisement Function ---- */

CREATE OR REPLACE FUNCTION public.updateadvertisement(
	var_advertisementid uuid,
	var_userid uuid,
    var_isselling boolean,
	var_advertisementtype character varying,
	var_entityid uuid,
	var_price float,
	var_description character varying,
	OUT res_updated boolean,
	OUT res_error character varying)
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    
AS $BODY$
DECLARE
BEGIN
IF EXISTS (SELECT 1 FROM public.advertisement u WHERE u.isdeleted = true AND u.id = var_advertisementid) THEN
	res_updated := false;
	res_error := 'This Advertisement is deleted!';
    ELSE
        UPDATE public.Advertisement
   	    SET id = var_advertisementid, isselling = var_isselling, advertisementtype = var_advertisementtype, entityid = var_entityid, price = var_price, description = var_description, modifieddatetime = CURRENT_TIMESTAMP 
        WHERE var_advertisementid = id AND isdeleted = false;
        res_updated := true;
	    res_error := 'Advert Successfully Updated';
    END IF;
END;
$BODY$;


/* ---- Delete Advertisement on ID Function ---- */

CREATE OR REPLACE FUNCTION public.deleteadvertisement(
	var_advertisementid uuid,
	OUT res_deleted boolean)
    RETURNS boolean
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    
AS $BODY$
DECLARE
BEGIN
    IF EXISTS (SELECT 1 FROM public.Advertisement u WHERE u.id = var_advertisementid) THEN
        UPDATE public.Advertisement
        SET isdeleted = true 
        WHERE var_advertisementid = id;
        res_deleted := true;
    ELSE
        res_deleted := false;
    END IF;
    
END;
$BODY$;

/* ---- Delete Advertisements pertaining to Users Function ---- */

CREATE OR REPLACE FUNCTION public.deleteuseradvertisements(
	var_userid uuid,
	OUT res_deleted boolean)
    RETURNS boolean
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    
AS $BODY$
DECLARE
BEGIN
    IF EXISTS (SELECT * FROM public.Advertisement u WHERE u.userid = var_userid) THEN
        UPDATE public.Advertisement
        SET isdeleted = true 
        WHERE var_userid = userid;
        res_deleted := true;
    ELSE
        res_deleted := false;
    END IF;
    
END;
$BODY$;

/* ---- Get Textbook Advertisements Ammount dictated by varibale sent to the function. ---- */

CREATE OR REPLACE FUNCTION public.gettextbookadvertisements(
	var_institution character varying,
	var_limit numeric,
	var_isselling boolean,
	var_maxprice numeric,
	var_modulecode character varying,
	var_name character varying,
	var_edition character varying,
	var_quality character varying,
	var_author character varying)
    RETURNS TABLE(advertisementid uuid, userid uuid, isselling boolean, advertisementtype character varying, price numeric, description character varying, textbookid uuid, textbookname character varying, edition character varying, quality character varying, author character varying, modulecode character varying, institutionname character varying) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT a.id, a.userid, a.isselling, a.advertisementtype, a.price, a.description, t.id, t.name, t.edition, t.quality, t.author, m.modulecode, i.name
    FROM public.Advertisement as a
	INNER JOIN public.Textbook as t 
	ON a.entityid = t.id
	INNER JOIN public.Module as m
	ON m.id = t.moduleid AND m.isdeleted = false
	INNER JOIN public.Institution as i
	ON i.id = a.InstitutionID
	WHERE i.name LIKE var_institution AND var_maxprice >= a.price AND 'TXB' = a.advertisementtype AND var_isselling = a.isselling AND a.isdeleted = false AND t.name LIKE var_name AND t.edition LIKE var_edition AND t.quality LIKE var_quality AND t.author LIKE var_author AND m.ModuleCode LIKE var_modulecode
	LIMIT var_limit;
END;
$BODY$;

/* ---- Get Tutor Advertisements Ammount dictated by varibale sent to the function. ---- */


CREATE OR REPLACE FUNCTION public.gettutoradvertisements(
    var_institution character varying,
	var_limit numeric,
    var_isselling boolean,
    var_maxprice numeric,
    var_subject character varying,
	var_yearcompleted character varying,
	var_venue character varying,
	var_notesincluded character varying,
	var_terms character varying,
    var_modulecode character varying
	)
    RETURNS TABLE(advertisementid uuid, userid uuid, isselling boolean, advertisementtype character varying, price numeric, description character varying, tutorid uuid, subject character varying, yearcompleted character varying, venue character varying, notesincluded boolean, terms character varying, modulecode character varying, institutionname character varying) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
    
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT a.id, a.userid, a.isselling, a.advertisementtype, a.price, a.description, t.id, t.subject, t.yearcompleted, t.venue, t.notesincluded, t.terms, m.modulecode, i.name
    FROM public.Advertisement as a
	INNER JOIN public.Tutor as t 
	ON a.entityid = t.id
	INNER JOIN public.Module as m
	ON m.id = t.moduleid AND m.isdeleted = false
    INNER JOIN public.Institution as i
	ON i.id = a.InstitutionID
	WHERE i.name LIKE var_institution AND var_maxprice >= a.price AND 'TUT' = a.advertisementtype AND var_isselling = a.isselling AND a.isdeleted = false AND t.subject LIKE var_subject AND t.yearcompleted LIKE var_yearCompleted AND t.venue LIKE var_venue AND CAST(t.notesincluded AS character varying) LIKE var_notesIncluded AND t.terms LIKE var_terms AND m.ModuleCode LIKE var_modulecode
	LIMIT var_limit;
END;
$BODY$;


/* ---- Get Note Advertisements Ammount dictated by varibale sent to the function. ---- */



CREATE OR REPLACE FUNCTION public.getnoteadvertisements(
    var_institution character varying,
    var_limit numeric,
    var_isselling boolean,
    var_maxprice numeric,
    var_modulecode character varying
	)
    RETURNS TABLE(advertisementid uuid, userid uuid, isselling boolean, advertisementtype character varying, price numeric, description character varying, noteid uuid, modulecode character varying, institutionname character varying) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
    
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT a.id, a.userid, a.isselling, a.advertisementtype, a.price, a.description, n.id, m.modulecode, i.name
    FROM public.Advertisement as a
	INNER JOIN public.Notes as n 
	ON a.entityid = n.id
	INNER JOIN public.Module as m
	ON m.id = n.moduleid AND m.isdeleted = false
    INNER JOIN public.Institution as i
	ON i.id = a.InstitutionID
	WHERE i.name LIKE var_institution AND var_maxprice >= a.price AND 'NTS' = a.advertisementtype AND var_isselling = a.isselling AND a.isdeleted = false AND m.ModuleCode LIKE var_modulecode
	LIMIT var_limit;
END;
$BODY$;

/* ---- Get Accomodation Advertisements Ammount dictated by varibale sent to the function. ---- */

CREATE OR REPLACE FUNCTION public.getaccomodationadvertisements(
    var_institutionname character varying,
    var_limit numeric,
    var_isselling boolean,
    var_maxprice numeric,
    var_accomodationcode character varying,
    var_location character varying,
    var_distancetocampus numeric
	)
    RETURNS TABLE(advertisementid uuid, userid uuid, isselling boolean, advertisementtype character varying, price numeric, description character varying, accomodationid uuid, accomodationtypecode character varying, location character varying, distancetocampus numeric, institutionname character varying) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
    
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT ad.id, ad.userid, ad.isselling, ad.advertisementtype, ad.price, ad.description, ac.id, ac.accomodationtypecode, ac.location, ac.distancetocampus, i.name
    FROM public.Advertisement as ad
	INNER JOIN public.Accomodation as ac 
	ON ad.entityid = ac.id
	INNER JOIN public.Institution as i
	ON i.id = ac.institutionid AND i.isdeleted = false
	WHERE var_maxprice >= ad.price AND 'ACD' = ad.advertisementtype AND var_isselling = ad.isselling AND ad.isdeleted = false AND i.name LIKE var_institutionname AND ac.accomodationtypecode LIKE var_accomodationcode AND ac.location LIKE var_location AND ac.distancetocampus <= var_distancetocampus
	LIMIT var_limit;
END;
$BODY$;


/* ---- Get Textbook Advertisement by User ID Function ---- */

CREATE OR REPLACE FUNCTION public.gettextbookadvertisementsbyuserid(
	var_userid uuid,
	var_limit numeric,
	var_isselling boolean)
    RETURNS TABLE(advertisementid uuid, userid uuid, isselling boolean, advertisementtype character varying, price numeric, description character varying, textbookid uuid, textbookname character varying, edition character varying, quality character varying, author character varying, modulecode character varying, institutionname character varying ) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
BEGIN
	RETURN QUERY
    SELECT a.id, a.userid, a.isselling, a.advertisementtype, a.price, a.description, t.id, t.name, t.edition, t.quality, t.author, m.modulecode, i.name
    FROM public.Advertisement as a
	INNER JOIN public.Textbook as t 
	ON a.entityid = t.id
	INNER JOIN public.Module as m
	ON m.id = t.moduleid AND m.isdeleted = false
    INNER JOIN public.Institution as i
	ON i.id = a.InstitutionID
	WHERE var_userid = a.userid AND 'TXB' = a.advertisementtype AND var_isselling = a.isselling AND a.isdeleted = false 
	LIMIT var_limit;
END;
$BODY$;

/* ---- Get Accomodation Advertisement by User ID Function ---- */
CREATE OR REPLACE FUNCTION public.getaccomodationadvertisementsbyuserid(
	var_userid uuid,
	var_limit numeric,
	var_isselling boolean)
    RETURNS TABLE(advertisementid uuid, userid uuid, isselling boolean, advertisementtype character varying, price numeric, description character varying, accomodationid uuid, accomodationtypecode character varying, location character varying, distancetocampus numeric, institution character varying) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT ad.id, ad.userid, ad.isselling, ad.advertisementtype, ad.price, ad.description, ac.id, ac.accomodationtypecode, ac.location, ac.distancetocampus, i.name
    FROM public.Advertisement as ad
	INNER JOIN public.Accomodation as ac 
	ON ad.entityid = ac.id
	INNER JOIN public.Institution as i
	ON i.id = ac.institutionid AND i.isdeleted = false
	WHERE var_userid = ad.userid AND 'ACD' = ad.advertisementtype AND var_isselling = ad.isselling AND ad.isdeleted = false
	LIMIT var_limit;
END;
$BODY$;

/* ---- Get Tutor Advertisement by User ID Function ---- */
CREATE OR REPLACE FUNCTION public.gettutoradvertisementsbyuserid(
	var_userid uuid,
	var_limit numeric,
	var_isselling boolean)
    RETURNS TABLE(advertisementid uuid, userid uuid, isselling boolean, advertisementtype character varying, price numeric, description character varying, tutorid uuid, subject character varying, yearcompleted character varying, venue character varying, notesincluded boolean, terms character varying, modulecode character varying, institutionname character varying) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT a.id, a.userid, a.isselling, a.advertisementtype, a.price, a.description, t.id, t.subject, t.yearcompleted, t.venue, t.notesincluded, t.terms, m.modulecode, i.name
    FROM public.Advertisement as a
	INNER JOIN public.Tutor as t 
	ON a.entityid = t.id
	INNER JOIN public.Module as m
	ON m.id = t.moduleid AND m.isdeleted = false
    INNER JOIN public.Institution as i
	ON i.id = a.InstitutionID
	WHERE var_userid = a.userid AND 'TUT' = a.advertisementtype AND var_isselling = a.isselling AND a.isdeleted = false
	LIMIT var_limit;
END;
$BODY$;

/* ---- Get Note Advertisement by User ID Function ---- */
CREATE OR REPLACE FUNCTION public.getnoteadvertisementsbyuserid(
	var_userid uuid,
	var_limit numeric,
	var_isselling boolean)
    RETURNS TABLE(advertisementid uuid, userid uuid, isselling boolean, advertisementtype character varying, price numeric, description character varying, noteid uuid, modulecode character varying, institutionname character varying) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT a.id, a.userid, a.isselling, a.advertisementtype, a.price, a.description, n.id, m.modulecode, i.name
    FROM public.Advertisement as a
	INNER JOIN public.Notes as n 
	ON a.entityid = n.id
	INNER JOIN public.Module as m
	ON m.id = n.moduleid AND m.isdeleted = false
    INNER JOIN public.Institution as i
	ON i.id = a.InstitutionID
	WHERE var_userid = a.userid AND 'NTS' = a.advertisementtype AND var_isselling = a.isselling AND a.isdeleted = false
	LIMIT var_limit;
END;
$BODY$;
/* ---- Get all advertisements Function ---- */

CREATE OR REPLACE FUNCTION public.getalladvertisements()
    RETURNS TABLE(advertisementid uuid, userid uuid, isselling boolean, advertisementtype character varying, entityid uuid, price numeric, description character varying)
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE
    ROWS 1000
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT u.id, u.userid, u.isselling, u.advertisementtype, u.entityid, u.price, u.description
    FROM public.Advertisement u
    WHERE isdeleted = false;
END;
$BODY$;

/* ---- Delete Textbook by id ---- */

CREATE OR REPLACE FUNCTION public.deletetextbook(
	var_textbookid uuid,
	OUT res_deleted boolean)
    RETURNS boolean
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    
AS $BODY$
DECLARE
BEGIN
    IF EXISTS (SELECT 1 FROM public.Textbook t WHERE t.id = var_textbookid) THEN
        UPDATE public.Textbook
        SET isdeleted = true 
        WHERE var_textbookid = id;
        res_deleted := true;
    ELSE
        res_deleted := false;
    END IF;
    
END;
$BODY$;

/* ---- Delete Tutor by id ---- */

CREATE OR REPLACE FUNCTION public.deletetutor(
	var_tutorid uuid,
	OUT res_deleted boolean)
    RETURNS boolean
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    
AS $BODY$
DECLARE
BEGIN
    IF EXISTS (SELECT 1 FROM public.Tutor t WHERE t.id = var_tutorid) THEN
        UPDATE public.Tutor
        SET isdeleted = true 
        WHERE var_tutorid = id;
        res_deleted := true;
    ELSE
        res_deleted := false;
    END IF;
    
END;
$BODY$;

/* ---- Delete Accomodation by id ---- */

CREATE OR REPLACE FUNCTION public.deleteaccomodation(
	var_accomodationid uuid,
	OUT res_deleted boolean)
    RETURNS boolean
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    
AS $BODY$
DECLARE
BEGIN
    IF EXISTS (SELECT 1 FROM public.Accomodation a WHERE a.id = var_accomodationid) THEN
        UPDATE public.Accomodation
        SET isdeleted = true 
        WHERE var_accomodationid = id;
        res_deleted := true;
    ELSE
        res_deleted := false;
    END IF;
    
END;
$BODY$;

/* ---- Delete Note by id ---- */

CREATE OR REPLACE FUNCTION public.deletenote(
	var_noteid uuid,
	OUT res_deleted boolean)
    RETURNS boolean
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    
AS $BODY$
DECLARE
BEGIN
    IF EXISTS (SELECT 1 FROM public.Notes n WHERE n.id = var_noteid) THEN
        UPDATE public.Notes
        SET isdeleted = true 
        WHERE var_noteid = id;
        res_deleted := true;
    ELSE
        res_deleted := false;
    END IF;
    
END;
$BODY$;

/* ---- Get Textbooks by Filter Function ---- */
CREATE OR REPLACE FUNCTION public.gettextbookbyfilter(
	var_modulecode character varying,
	var_name character varying,
	var_edition character varying,
	var_quality character varying,
	var_author character varying)
    RETURNS TABLE(modulecode character varying, id uuid, name character varying, edition character varying, quality character varying, author character varying) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
    
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT m.modulecode, t.id, t.name, t.edition, t.quality, t.author
    FROM public.Textbook t
	INNER JOIN public.Module m  
	ON m.id = t.moduleid AND m.isdeleted = false
    WHERE t.name LIKE var_name AND t.edition LIKE var_edition AND t.quality LIKE var_quality AND t.author LIKE var_author AND m.ModuleCode LIKE var_modulecode AND t.IsDeleted = false;
END;
$BODY$;

/* ---- Get Tutors by Filter Function ---- */
CREATE OR REPLACE FUNCTION public.gettutorbyfilter(
	var_modulecode character varying,
	var_subject character varying,
	var_yearcompleted character varying,
	var_venue character varying,
	var_notesincluded character varying,
	var_terms character varying)
    RETURNS TABLE(modulecode character varying, id uuid, subject character varying, yearcompleted character varying, venue character varying, notesincluded boolean, terms character varying) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
    
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT m.modulecode, t.id, t.subject, t.yearcompleted, t.venue, t.notesincluded, t.terms
    FROM public.Tutor t
	INNER JOIN public.Module m  
	ON m.id = t.moduleid AND m.isdeleted = false
    WHERE t.subject LIKE var_subject AND t.yearcompleted LIKE var_yearCompleted AND t.venue LIKE var_venue AND CAST(t.notesincluded AS character varying) LIKE var_notesIncluded AND t.terms LIKE var_terms AND m.ModuleCode LIKE var_modulecode AND t.IsDeleted = false;
END;
$BODY$;

/* ---- Get Accomodation by Filter Function ---- */
CREATE OR REPLACE FUNCTION public.getaccomodationbyfilter(
	var_accomodationcode character varying,
    var_institutionname character varying,
    var_location character varying,
    var_distancetocampus numeric)
    RETURNS TABLE(id uuid, institution character varying, accomodationtypecode character varying, location character varying, distancetocampus numeric) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
    
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT a.id, i.name, a.accomodationtypecode, a.location, a.distancetocampus
    FROM public.Accomodation a
	INNER JOIN public.Institution i  
	ON i.id = a.institutionid AND i.isdeleted = false
    WHERE i.name LIKE var_institutionname AND a.accomodationtypecode LIKE var_accomodationcode AND a.location LIKE var_location AND a.distancetocampus <= var_distancetocampus AND a.isdeleted = false;
END;
$BODY$;

/* ---- Get Notes by Filter Function ---- */
CREATE OR REPLACE FUNCTION public.getnotesbyfilter(
	var_modulecode character varying)
    RETURNS TABLE(modulecode character varying, id uuid) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
    
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT m.modulecode, n.id
    FROM public.Notes n
	INNER JOIN public.Module m  
	ON m.id = n.moduleid AND m.isdeleted = false
    WHERE m.ModuleCode LIKE var_modulecode AND n.isdeleted = false;
END;
$BODY$;

/* ---- Update Textbook Function ---- */
CREATE OR REPLACE FUNCTION public.updatetextbook(
	var_textbookid uuid,
	var_modulecode character varying,
	var_name character varying,
	var_edition character varying,
	var_quality character varying,
	var_author character varying,
	OUT res_updated boolean,
	OUT res_error character varying)
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    
AS $BODY$
DECLARE
var_moduleid uuid;
BEGIN
IF EXISTS (SELECT 1 FROM public.Module m WHERE m.modulecode = var_modulecode AND m.isdeleted = false) THEN
SELECT m.id
    INTO var_moduleid 
    FROM public.Module m  
    WHERE m.modulecode = var_modulecode AND m.isdeleted = false;
	IF EXISTS (SELECT 1 FROM public.textbook t WHERE t.isdeleted = true AND t.id = var_textbookid) THEN
		res_updated := false;
		res_error := 'This Textbook is deleted! Update Failed!';
    	ELSE
        	UPDATE public.Textbook t
   	    	SET moduleid = var_moduleid, name = var_name, edition = var_edition, quality = var_quality, author = var_author, modifieddatetime = CURRENT_TIMESTAMP 
        	WHERE t.id = var_textbookid AND t.isdeleted = false;
        	res_updated := true;
	    	res_error := 'Textbook Successfully Updated';
    	END IF;
		ELSE 
			res_updated := false;
			res_error := 'This Module code does not exist!';
		END if;
END;
$BODY$;

/* ---- Update Tutor Function ---- */
CREATE OR REPLACE FUNCTION public.updatetutor(
	var_tutorid uuid,
	var_modulecode character varying,
	var_subject character varying,
	var_yearcompleted character varying,
	var_venue character varying,
	var_notesincluded boolean,
	var_terms character varying,
	OUT res_updated boolean,
	OUT res_error character varying)
    RETURNS record
    LANGUAGE 'plpgsql'
        COST 100
    VOLATILE 
    
AS $BODY$
DECLARE
var_moduleid uuid;
BEGIN
IF EXISTS (SELECT 1 FROM public.Module m WHERE m.modulecode = var_modulecode AND m.isdeleted = false) THEN
SELECT m.id
    INTO var_moduleid 
    FROM public.Module m  
    WHERE m.modulecode = var_modulecode AND m.isdeleted = false;
	IF EXISTS (SELECT 1 FROM public.tutor t WHERE t.isdeleted = true AND t.id = var_tutorid) THEN
		res_updated := false;
		res_error := 'This Tutor is deleted! Update Failed!';
    	ELSE
        	UPDATE public.Tutor t
   	    	SET moduleid = var_moduleid, subject= var_subject, yearcompleted = var_yearcompleted, venue = var_venue, notesincluded = var_notesincluded, terms = var_terms, modifieddatetime = CURRENT_TIMESTAMP 
        	WHERE t.id = var_tutorid AND t.isdeleted = false;
        	res_updated := true;
	    	res_error := 'Tutor Successfully Updated';
    	END IF;
		ELSE 
			res_updated := false;
			res_error := 'This Module code does not exist!';
		END if;
END;
$BODY$;
/* ---- Get Advertisements by Selling or Looking for Function ---- */

CREATE OR REPLACE FUNCTION public.getadvertisementbyposttype(
	var_isselling boolean)
    RETURNS TABLE(advertisementid uuid, userid uuid, isselling boolean, advertisementtype character varying, entityid uuid, price numeric, description character varying)
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE
    ROWS 1000
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT u.id, u.userid, u.isselling, u.advertisementtype, u.entityid, u.price, u.description
    FROM public.Advertisement u
    WHERE var_isselling  = u.isselling AND isdeleted = false;
END;
$BODY$;

/* ---- Handle Forgot Password Function ---- */


CREATE OR REPLACE FUNCTION public.forgotpassword(
	var_email character varying,
	OUT res_email character varying,
	OUT res_password character varying,
	OUT res_error character varying)
    RETURNS record
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE
AS $BODY$
DECLARE
DECLARE
test_password character varying = array_to_string(ARRAY(SELECT chr((65 + round(random() * 25)) :: integer) 
FROM generate_series(1,8)), '');
BEGIN
IF EXISTS (SELECT 1 FROM public.User u WHERE u.email = var_email AND u.isdeleted = false) THEN 
 UPDATE public.User
 SET password = test_password, modifieddatetime = CURRENT_TIMESTAMP
 WHERE var_email = email;
    res_email = var_email;
    res_password = test_password;
	res_error := 'A new password is being sent to you now, please check your email';
    ELSE
        res_email = 'None';
        res_password = 'None';
        res_error = 'A new password cannot be granted at this time as an appropriate email address has not been provided';
    END IF;
END;
$BODY$;



/* ---- Update Accomodation Function ---- */

CREATE OR REPLACE FUNCTION public.updateaccomodation(
	var_accomodationid uuid,
	var_accomodationtypecode character varying,
	var_institutionname character varying,
	var_location character varying,
	var_distancetocampus numeric,
	OUT res_updated boolean,
	OUT res_error character varying)
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    
AS $BODY$
DECLARE
var_institutionid uuid;
BEGIN
IF EXISTS (SELECT 1 FROM public.institution i WHERE i.name = var_institutionname AND i.isdeleted = false) THEN
SELECT i.id
    INTO var_institutionid
    FROM public.Institution i  
    WHERE i.name = var_institutionname AND i.isdeleted = false;
	IF EXISTS (SELECT 1 FROM public.Accomodation a WHERE a.isdeleted = true AND a.id = var_accomodationid) THEN
		res_updated := false;
		res_error := 'This Accomodation is deleted! Update Failed!';
    	ELSE
        	UPDATE public.Accomodation a
   	    	SET accomodationtypecode = var_accomodationTypeCode, institutionid = var_institutionid, location = var_location, distancetocampus = var_distanceToCampus, modifieddatetime = CURRENT_TIMESTAMP 
        	WHERE a.id = var_accomodationid AND a.isdeleted = false;
        	res_updated := true;
	    	res_error := 'Accomodation Successfully Updated';
    	END IF;
		ELSE 
			res_updated := false;
			res_error := 'This Institution does not exist!';
		END if;
END;
$BODY$;

/* ---- Update Note Function ---- */
CREATE OR REPLACE FUNCTION public.updatenote(
	var_noteid uuid,
	var_modulecode character varying,
	OUT res_updated bool,
	OUT res_error character varying
    )
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    
AS $BODY$
DECLARE
var_moduleid uuid;
BEGIN
IF EXISTS (SELECT 1 FROM public.Module m WHERE m.modulecode = var_modulecode AND m.isdeleted = false) THEN
SELECT m.id
    INTO var_moduleid 
    FROM public.Module m  
    WHERE m.modulecode = var_modulecode AND m.isdeleted = false;
	IF EXISTS (SELECT 1 FROM public.Notes n WHERE n.isdeleted = true AND n.id = var_noteid) THEN
		res_updated := false;
		res_error := 'This Note is deleted! Update Failed!';
    	ELSE
        	UPDATE public.Notes n
   	    	SET moduleid = var_moduleid, modifieddatetime = CURRENT_TIMESTAMP 
        	WHERE n.id = var_noteid AND n.isdeleted = false;
        	res_updated := true;
	    	res_error := 'Note Successfully Updated';
    	END IF;
		ELSE 
			res_updated := false;
			res_error := 'This Module code does not exist!';
		END if;
END;
$BODY$;


/* ---------------------------------------------------------------------
------------------------------------------------------------------------
-------------------------Image Functions----------------------------
------------------------------------------------------------------------
----------------------------------------------------------------------*/

CREATE OR REPLACE FUNCTION public.getcardmainimage(
	var_entityid uuid,
	OUT ret_filepath character varying,
	OUT ret_filename character varying)
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
	
	

	IF EXISTS (SELECT 1
    FROM public.AdvertisementImage ai
    INNER JOIN public.Image i ON i.ID = ai.ImageID AND i.IsMainImage = true
    WHERE ai.AdvertisingID = var_entityid) 
	THEN
		SELECT PathString, FileName
		INTO ret_filepath, ret_filename
		FROM public.AdvertisementImage ai
		INNER JOIN public.Image i ON i.ID = ai.ImageID AND i.IsMainImage = true
		WHERE ai.AdvertisingID = var_entityid;
	ELSE 
		ret_filepath = '';
		ret_filename = '';
	END IF;
END;
$BODY$;


CREATE OR REPLACE FUNCTION public.getcardmainimagelist(
	VARIADIC params uuid[])
    RETURNS TABLE(entityid uuid, pathstring varchar(256), filename varchar(256))
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
	
	RETURN QUERY
	SELECT ai.AdvertisingID , i.pathstring, i.filename
    FROM public.AdvertisementImage ai
    INNER JOIN public.Image i ON i.ID = ai.ImageID AND i.isdeleted = false
    WHERE ai.AdvertisingID = ANY (params) AND i.IsMainImage = true;
	
END;
$BODY$;

/* ############################################################################## */
CREATE OR REPLACE FUNCTION public.getadvertisementimages(
	var_entityid uuid)
    RETURNS TABLE(entityid uuid, pathstring varchar(256), filename varchar(256))
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN

    IF EXISTS(SELECT 1
        FROM public.AdvertisementImage ai
        INNER JOIN public.Image i ON i.ID = ai.ImageID AND i.isdeleted = false
        WHERE ai.AdvertisingID = var_entityid)
    THEN 
        RETURN QUERY
        SELECT ai.AdvertisingID , i.pathstring, i.filename
        FROM public.AdvertisementImage ai
        INNER JOIN public.Image i ON i.ID = ai.ImageID AND i.isdeleted = false
        WHERE ai.AdvertisingID = var_entityid;
	ELSE
        RETURN QUERY
        SELECT var_entityid , 'default'::character varying, 'default'::character varying;
    END IF;

END;
$BODY$;

/* ############################ INSERT IMAGE DATA INTO DB ##################################### */
CREATE OR REPLACE FUNCTION public.addimage(
	var_pathstring character varying,
	var_ismainimage boolean,
	var_filename character varying,
	var_entityid uuid,
	OUT res_imageinserted boolean,
	OUT ret_message character varying)
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
    imageid uuid := uuid_generate_v4();
BEGIN
	INSERT INTO public.image(id, pathstring, filename, ismainimage, createddatetime, isdeleted, modifieddatetime)
	VALUES(imageid, var_pathstring, var_filename, var_ismainimage, CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP );

	INSERT INTO public.advertisementimage(advertisingid, imageid, createddatetime, isdeleted, modifieddatetime)
	VALUES (var_entityid, imageid, CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
	
    res_imageinserted := true;
	ret_message := 'Advert Successfully Created!';
END;
$BODY$;


/* ---------------------------------------------------------------------
------------------------------------------------------------------------
-------------------------Messaging functions----------------------------
------------------------------------------------------------------------
----------------------------------------------------------------------*/

/*-------           Start chat function    ------*/
CREATE OR REPLACE FUNCTION public.addchat(
	var_sellerid uuid,
	var_buyerid uuid,
	var_advertisementtype character varying,
	var_advertisementid uuid,
	OUT ret_success boolean,
	OUT ret_chatid uuid)
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
    id uuid := uuid_generate_v4();
BEGIN
IF EXISTS (SELECT 1 FROM public.chat c WHERE c.sellerid = var_sellerid AND c.buyerid = var_buyerid AND c.advertisementid = var_advertisementid) THEN
    SELECT c.id
	INTO ret_chatid
    FROM public.Chat c
    WHERE c.sellerid = var_sellerid AND c.buyerid = var_buyerid AND c.advertisementid = var_advertisementid;
	ret_success := false;
	ELSE
	INSERT INTO public.Chat(ID, SellerID, BuyerID, AdvertisementType, AdvertisementID, ISActive, CreatedDateTime, IsDeleted, ModifiedDateTime)
    VALUES (id, var_sellerid, var_buyerid, var_advertisementtype, var_advertisementid, 'true', CURRENT_TIMESTAMP , 'false', CURRENT_TIMESTAMP);
    ret_success := true;
    ret_chatid := id;
	END IF;
END;
$BODY$;

/* -------Delete chat functon ----------- */
CREATE OR REPLACE FUNCTION public.deletechat(
	var_chatid uuid,
	OUT res_deleted boolean)
    RETURNS boolean
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
BEGIN
    IF EXISTS (SELECT 1 FROM public.Chat u WHERE u.id = var_chatid) THEN
        UPDATE public.Chat
        SET isdeleted = true, isactive = false, modifieddatetime = CURRENT_TIMESTAMP  
        WHERE var_chatid = id;
        res_deleted := true;
    ELSE
        res_deleted := false;
    END IF;
    
END;
$BODY$;

/* ---------- View active chats function  --------- */
CREATE OR REPLACE FUNCTION public.getactivechats(
	var_userid uuid)
    RETURNS TABLE(id uuid, advertisementtype character varying, advertisementid uuid, username character varying, price numeric, title character varying, description character varying, message character varying, messagedate timestamp without time zone, isread boolean, messageauthor character varying) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
DECLARE
var_advertisementtype  character varying;
BEGIN
	SELECT a.advertisementtype
	INTO var_advertisementtype
	FROM public.Advertisement a, public.Chat c
	WHERE a.id = c.advertisementid;
	RETURN QUERY
	SELECT c.id, c.advertisementtype, c.advertisementid, COALESCE(s.username, b.username),   a.price, COALESCE(txb.name, COALESCE(act.name, COALESCE(nmod.name, tut.subject))), a.description,
	(
		SELECT m.message
		FROM public.message m
		WHERE m.chatid = c.id AND m.isdeleted = false
		ORDER BY m.messagedate DESC
		limit 1
	), 
	(
		SELECT m.messagedate
		FROM public.message m
		WHERE m.chatid = c.id AND m.isdeleted = false
		ORDER BY m.messagedate DESC
		limit 1
	),
    (
		SELECT m.isread
		FROM public.message m
		WHERE m.chatid = c.id AND m.isdeleted = false
		ORDER BY m.messagedate DESC
		limit 1
	),
	(
		SELECT  u.username
		FROM public.message m
		INNER JOIN public.User as u
        ON u.id = m.authorid 
		WHERE m.chatid = c.id AND m.isdeleted = false
		ORDER BY m.messagedate DESC
		limit 1
	)
    FROM public.Chat as c
	LEFT JOIN public.User as s 
	ON c.sellerid = s.id AND s.isdeleted = false AND s.id != var_userid
	LEFT JOIN public.User as b
	ON c.buyerid = b.id AND b.isdeleted = false AND b.id != var_userid
	LEFT JOIN public.Advertisement as a
	ON c.advertisementid = a.id
	--JOIN ONTO THE CORRECT ADD TYPE
    LEFT JOIN public.Textbook as txb
    ON a.entityid = txb.id AND txb.isdeleted = false
	LEFT JOIN public.Tutor as tut
	ON tut.id = a.entityid AND tut.isdeleted = false
	LEFT JOIN public.Notes n
	ON n.id = a.entityid AND n.isdeleted = false
	LEFT JOIN public.module nmod
	ON nmod.id = n.moduleid AND nmod.isdeleted = false
	LEFT JOIN public.accomodation acc
	ON acc.id = a.entityid AND acc.isdeleted = false
	LEFT JOIN public.accomodationtype act
	ON act.code = acc.accomodationtypecode
	WHERE c.isactive = true  AND (c.sellerid = var_userid OR c.buyerid = var_userid);

END;
$BODY$;


/* ---------- View unread messages function  --------- */
CREATE OR REPLACE FUNCTION public.unreadmessages(
	var_userid uuid,
	OUT res_unreadmessages boolean)
    RETURNS boolean
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
BEGIN
    IF EXISTS (SELECT 1 FROM public.Message m 
			   INNER JOIN public.Chat as c ON m.chatid = c.id WHERE m.authorid != var_userid AND m.isread = false AND c.isactive = true AND c.sellerid = var_userid) THEN
        res_unreadmessages := true;
    ELSE IF EXISTS (SELECT 1 FROM public.Message m 
			   INNER JOIN public.Chat as c ON m.chatid = c.id WHERE m.authorid != var_userid AND m.isread = false AND c.isactive = true AND c.buyerid = var_userid) THEN
        res_unreadmessages := true;
	ELSE
        res_unreadmessages := false;
    END IF;
    END IF;
END;
$BODY$;

/* -----View Messages function -------- */
CREATE OR REPLACE FUNCTION public.getchat(
	var_userid uuid,
	var_chatid uuid)
    RETURNS TABLE(id uuid, username character varying, message character varying, messagedate timestamp without time zone) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
BEGIN
 UPDATE public.Message as m
   	    SET isread = true
 WHERE m.authorid != var_userid;
RETURN QUERY
SELECT m.id, u.username, m.message, m.messagedate
FROM public.Message as m
INNER JOIN public.Chat as c
ON m.chatid = c.id
INNER JOIN public.User as u
ON u.id = m.authorid 

WHERE m.isdeleted = false AND c.id = var_chatid AND c.isactive = true AND m.authorid = u.id
ORDER BY m.messagedate;
END;
$BODY$;





/* -------- Add message ---------- */
CREATE OR REPLACE FUNCTION public.sendmessage(
	var_chatid uuid,
	var_authorid uuid,
	var_message character varying)
    RETURNS TABLE(id uuid, username character varying, message character varying, messagedate timestamp) 
    LANGUAGE 'plpgsql'

     COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
DECLARE
id uuid := uuid_generate_v4();
BEGIN
INSERT INTO public.Message(ID, ChatID,
AuthorID, Message, MessageDate, CreatedDateTime,
IsDeleted, ModifiedDateTime)
VALUES (id, var_chatid,var_authorid, var_message,
CURRENT_TIMESTAMP , CURRENT_TIMESTAMP,
'false', CURRENT_TIMESTAMP);
RETURN QUERY
SELECT m.id, u.username, m.message, m.messagedate
FROM public.Message as m
INNER JOIN public.Chat as c
ON m.chatid = c.id
INNER JOIN public.User as u
ON u.id = m.authorid 

WHERE m.isdeleted = false AND c.id = var_chatid AND c.isactive = true AND m.authorid = u.id
ORDER BY m.messagedate;



END;
$BODY$;

/* ---------------------------------------------------------------------
------------------------------------------------------------------------
----------------------------Rating functions----------------------------
------------------------------------------------------------------------
----------------------------------------------------------------------*/

/*-------           Initial rating function    ------*/
CREATE OR REPLACE FUNCTION public.ratebuyer(
	var_advertisementid uuid,
	var_buyerid uuid,
	var_sellerid uuid,
	var_buyerrating double precision,
	var_buyercomments character varying,
	OUT ret_rated boolean,
	OUT ret_ratingid uuid)
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
    id uuid := uuid_generate_v4();
BEGIN
IF EXISTS (SELECT 1 FROM public.rating r WHERE r.advertisementid = var_advertisementid AND r.buyerid = var_buyerid) THEN
		ret_rated := false;
        ret_ratingid := '00000000-0000-0000-0000-000000000000';
    ELSE    
	INSERT INTO public.Rating(ID, AdvertisementID, SellerID, BuyerID, BuyerRating, BuyerComments, CreatedDateTime, IsDeleted, ModifiedDateTime)
    VALUES (id, var_advertisementid, var_sellerid, var_buyerid, var_buyerrating, var_buyercomments,  CURRENT_TIMESTAMP , 'false', CURRENT_TIMESTAMP);
    ret_rated := true;
    ret_ratingid := id;
    END IF;
END;
$BODY$;


/*-------           Seller rating function    ------*/
CREATE OR REPLACE FUNCTION public.rateseller(
	var_ratingid uuid,
	var_sellerrating double precision,
	var_sellercomments character varying,
	OUT ret_rated boolean)
    RETURNS boolean
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
	IF EXISTS (SELECT 1 FROM public.rating r WHERE r.sellerrating is not null AND r.id = var_ratingid AND r.sellercomments is not null) THEN
	ret_rated := false;
    ELSE
        UPDATE public.Rating
   	    SET sellerrating = var_sellerrating, sellercomments =  var_sellercomments , modifieddatetime = CURRENT_TIMESTAMP 
        WHERE id = var_ratingid AND isdeleted = false;
        ret_rated := true;
    END IF;
END;
$BODY$;


/* ---------- View outstanding ratings function  --------- */
CREATE OR REPLACE FUNCTION public.getoutstandingratings(
	var_userid uuid)
    RETURNS TABLE(id uuid, username character varying, price numeric, title character varying, description character varying) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
DECLARE
var_advertisementtype  character varying;
BEGIN
	SELECT a.advertisementtype
	INTO var_advertisementtype
	FROM public.Advertisement a, public.Rating r
	WHERE a.id = r.advertisementid;
	RETURN QUERY
	SELECT r.id, COALESCE(s.username, b.username), a.price, COALESCE(txb.name, COALESCE(act.name, COALESCE(nmod.name, tut.subject))), a.description
    FROM public.Rating as r
	--This is to see if the other user is the seller
	LEFT JOIN public.User as s
	ON r.sellerid = s.id AND s.isdeleted = false AND s.id != var_userid
	--This is to see if the other user is the buyer
	LEFT JOIN public.User as b
	ON r.buyerid = b.id AND b.isdeleted = false AND b.id != var_userid
	LEFT JOIN public.Advertisement as a
	ON r.advertisementid = a.id 
	--JOIN ONTO THE CORRECT ADD TYPE
    LEFT JOIN public.Textbook as txb
    ON a.entityid = txb.id AND txb.isdeleted = false
	LEFT JOIN public.Tutor as tut
	ON tut.id = a.entityid AND tut.isdeleted = false
	LEFT JOIN public.Notes n
	ON n.id = a.entityid AND n.isdeleted = false
	LEFT JOIN public.module nmod
	ON nmod.id = n.moduleid AND nmod.isdeleted = false
	LEFT JOIN public.accomodation acc
	ON acc.id = a.entityid AND acc.isdeleted = false
	LEFT JOIN public.accomodationtype act
	ON act.code = acc.accomodationtypecode
    WHERE r.isdeleted = false AND r.sellerrating is null AND r.buyerid = var_userid;
END;
$BODY$;

CREATE OR REPLACE FUNCTION public.ratingstodo(
	var_userid uuid,
	OUT res_outstanding boolean)
    RETURNS boolean
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
BEGIN
    IF EXISTS (SELECT 1 FROM public.Rating r WHERE r.isdeleted = false AND r.sellerrating is null AND r.buyerid = var_userid) THEN
        res_outstanding := true;
	ELSE
        res_outstanding := false;
    END IF;
END;
$BODY$;

/* ---------- Ratings as a seller dasboard function  --------- */

CREATE OR REPLACE FUNCTION public.sellerratings(
	var_userid uuid)
    RETURNS TABLE(id uuid, username character varying, rating numeric, comment character varying) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT r.id, u.username, r.sellerrating, r.sellercomments 
    FROM public.Rating as r
	LEFT JOIN public.User as u 
	ON r.buyerid = u.id AND u.id != var_userid
	WHERE r.isdeleted = false AND r.sellerrating is not null AND r.sellerid = var_userid;

END;
$BODY$;

/* ---------- Ratings as a buyer dasboard function  --------- */
CREATE OR REPLACE FUNCTION public.buyerratings(
	var_userid uuid)
    RETURNS TABLE(id uuid, username character varying, rating numeric, comment character varying) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT r.id, u.username, r.buyerrating, r.buyercomments 
    FROM public.Rating as r
	LEFT JOIN public.User as u 
	ON r.sellerid = u.id AND u.id != var_userid
	WHERE r.isdeleted = false AND r.buyerrating is not null AND r.buyerid = var_userid;

END;
$BODY$;

/* ---------- View interested buyers function  --------- */
CREATE OR REPLACE FUNCTION public.getinterestedbuyers(
	var_userid uuid,
	var_advertisementid uuid)
    RETURNS TABLE(username character varying, advertisementid uuid, advertisementtype character varying, sellerid uuid, buyerid uuid) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT u.username, c.advertisementid, c.advertisementtype, c.sellerid, c.buyerid
    FROM public.Chat as c
	LEFT JOIN public.User as u 
	ON c.buyerid = u.id 
	WHERE c.israted = false AND c.advertisementid = var_advertisementid AND c.sellerid = var_userid;

END;
$BODY$;

/* ---------- Buyer dashboard function  --------- */
CREATE OR REPLACE FUNCTION public.buyerdashboard(
	var_userid uuid)
    RETURNS TABLE(rating numeric) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT COALESCE (AVG(DISTINCT buyerrating),0) as "Buyer Rating" 
    FROM public.Rating as r
	WHERE r.isdeleted = false AND r.buyerrating != 0 AND r.buyerid = var_userid;

END;
$BODY$;

/* ---------- Buyer dashboard function  --------- */
CREATE OR REPLACE FUNCTION public.sellerdashboard(
	var_userid uuid)
    RETURNS TABLE(rating numeric) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT COALESCE (AVG(DISTINCT sellerrating),0) as "Seller Rating" 
    FROM public.Rating as r
	WHERE r.isdeleted = false AND r.sellerrating != 0 AND r.sellerid = var_userid;

END;
$BODY$;

CREATE OR REPLACE FUNCTION public.requestotp(
	var_userid uuid,
	var_phonenumber character varying,
	OUT ret_sent boolean,
	OUT ret_message character varying,
	OUT ret_phonenumber character varying,
	OUT ret_otp character varying)
    RETURNS record 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
    id uuid := uuid_generate_v4();
    generated_otp double precision = array_to_string(ARRAY(SELECT chr((48 + round(random() * 9)) :: integer) 
FROM generate_series(1,5)), '');
BEGIN
	IF EXISTS (SELECT 1 FROM public.uservalidation u WHERE u.userid = var_userid AND u.validationstatus = 'OTP Sent' AND u.phonenumber = var_phonenumber) THEN
		ret_sent := false;
		ret_message := 'An OTP has already been sent to this number. Try the resend OTP option if you did not recieve an OTP.';
        ret_phonenumber := '000';
        ret_otp := 'None';
			ELSE IF EXISTS (SELECT 1 FROM public.uservalidation u WHERE u.userid = var_userid AND u.validationstatus = 'OTP Validated') THEN
				ret_sent := false;
		        ret_message := 'An OTP has already been validated by this number. Try the resend OTP option if you did not recieve an OTP.';
                ret_phonenumber := '00';
                ret_otp := 'None';
					ELSE IF EXISTS (SELECT 1 FROM public.uservalidation u WHERE u.phonenumber = var_phonenumber) THEN
							ret_sent := false;
		       			    ret_message := 'This number has already been used to validate an account';
               			    ret_phonenumber := '0';
                			ret_otp := 'None';
					ELSE
						INSERT INTO public.UserValidation(ID, UserID, PhoneNumber, OTP, SentDate, CreatedDateTime, IsDeleted, ModifiedDateTime)
    					VALUES (id, var_userid, var_phonenumber, generated_otp ,CURRENT_TIMESTAMP , CURRENT_TIMESTAMP , 'false', CURRENT_TIMESTAMP);
    					ret_sent := true;
		                ret_message := 'An OTP has successfully been sent to your phone!';
                        ret_phonenumber := var_phonenumber;
                        ret_otp := generated_otp;
    				END IF;
				END IF;
			END IF;
END;
$BODY$;


CREATE OR REPLACE FUNCTION public.validateotp(
	var_userid uuid,
	var_otp character varying,
	OUT ret_userid uuid,
	OUT ret_successvalidation boolean,
	OUT ret_message character varying)
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
IF EXISTS (SELECT 1 FROM public.UserValidation u WHERE u.userid = var_userid AND u.otp = var_otp AND u.validationstatus = 'OTP Sent') THEN
    UPDATE public.UserValidation
   	SET validationstatus = 'OTP Validated', modifieddatetime = CURRENT_TIMESTAMP 
    WHERE var_userid = userid AND isdeleted = false;
	ret_userid = var_userid;
    ret_successvalidation = true;
    ret_message = 'Your account has been successfully verified. You have been granted 3 free advertisements';
    ELSE
	    ret_userid = '00000000-0000-0000-0000-000000000000';
        ret_successvalidation = false;
		ret_message = 'The OTP you entered is incorrect.';
    END IF;
END;
$BODY$;

CREATE OR REPLACE FUNCTION public.grantads(
	var_userid uuid,
	OUT ret_successvalidation boolean,
	OUT ret_message character varying)
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
IF EXISTS (SELECT 1 FROM public.UserValidation u WHERE u.userid = var_userid AND u.validationstatus = 'OTP Validated') THEN
    UPDATE public.User
   	SET advertisementsremaining = advertisementsremaining + 3, modifieddatetime = CURRENT_TIMESTAMP 
    WHERE var_userid = id AND isdeleted = false;
    ret_successvalidation = true;
    ret_message = 'Your account has been successfully verified. You have been granted 3 free advertisements.';
    ELSE
        ret_successvalidation = false;
		ret_message = 'The OTP you entered is incorrect.';
    END IF;
END;
$BODY$;

CREATE OR REPLACE FUNCTION public.newotp(
	var_userid uuid,
	var_phonenumber character varying,
	OUT ret_sent boolean,
	OUT ret_message character varying,
	OUT ret_phonenumber character varying,
	OUT ret_otp character varying)
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
    id uuid := uuid_generate_v4();
    generated_otp double precision = array_to_string(ARRAY(SELECT chr((48 + round(random() * 9)) :: integer) 
FROM generate_series(1,5)), '');
BEGIN
	IF EXISTS (SELECT 1 FROM public.uservalidation u WHERE u.userid = var_userid AND u.validationstatus = 'OTP Expired') THEN
		ret_sent := false;
		ret_message := 'An OTP has already been sent again. Please wait a few minutes as a delay can sometimes occur.';
        ret_phonenumber := '00000';
        ret_otp := 'None';
			ELSE IF EXISTS (SELECT 1 FROM public.uservalidation u WHERE u.userid = var_userid AND u.phonenumber = var_phonenumber AND u.validationstatus = 'OTP Validated') THEN
				ret_sent := false;
		        ret_message := 'Your account has already been verified!';
                ret_phonenumber := '0000';
                ret_otp := 'None';
					ELSE
						UPDATE public.UserValidation
  					 	SET validationstatus = 'OTP Expired', modifieddatetime = CURRENT_TIMESTAMP 
    					WHERE userid = var_userid AND isdeleted = false AND validationstatus = 'OTP Sent';
						INSERT INTO public.UserValidation(ID, UserID, PhoneNumber, OTP, SentDate, CreatedDateTime, IsDeleted, ModifiedDateTime)
    					VALUES (id, var_userid, var_phonenumber, generated_otp ,CURRENT_TIMESTAMP , CURRENT_TIMESTAMP , 'false', CURRENT_TIMESTAMP);
    					ret_sent := true;
		                ret_message := 'A new OTP has successfully been sent to your phone!';
                        ret_phonenumber := var_phonenumber;
                        ret_otp := generated_otp;
    				END IF;
			END IF;
END;
$BODY$;

CREATE OR REPLACE FUNCTION public.verifieduser(
	var_userid uuid,
	OUT ret_isverified boolean)
    RETURNS boolean
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
IF EXISTS (SELECT 1 FROM public.UserValidation u WHERE u.userid = var_userid AND u.validationstatus = 'OTP Validated') THEN
    ret_isverified = true;
    ELSE
        ret_isverified = false;
    END IF;
END;
$BODY$;

/* =====================================================
===================== PURCHASE ADDS FUNCTION ===========
=======================================================*/

CREATE OR REPLACE FUNCTION public.purchaseads(
	var_userid uuid,
	var_ammount integer,
	OUT ret_success boolean,
	OUT ret_message character varying)
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
IF EXISTS (SELECT 1 FROM public.user u WHERE u.id = var_userid) THEN
    UPDATE public.User
   	SET advertisementsremaining = advertisementsremaining + var_ammount, modifieddatetime = CURRENT_TIMESTAMP 
    WHERE var_userid = id AND isdeleted = false;
    ret_success = true;
    ret_message = 'Success! Your account has been credited with advertisement tokens.';
    ELSE
        ret_success = false;
		ret_message = 'Internal Error!';
    END IF;
END;
$BODY$;


/* =====================================================
========== GET PASSWORD FOR WSO2 FUNCTION ==============
=======================================================*/

CREATE OR REPLACE FUNCTION public.getpassword(
	var_email character varying,
	OUT ret_varid uuid,
	OUT ret_username character varying,
	OUT ret_password character varying,
	OUT ret_successget boolean)
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
IF EXISTS (SELECT 1 FROM public.User u WHERE u.email = var_email AND u.isdeleted = false) THEN
	SELECT u.id, u.username, u.password
	INTO ret_varid, ret_username, ret_password
    FROM public.User u
    WHERE var_email = u.email AND u.isdeleted = false;
	ret_successget = true;
	ELSE
        ret_varid = '00000000-0000-0000-0000-000000000000';
        ret_username = 'none';
		ret_password = 'none';
        ret_successget = false; 
    END IF;
END;
$BODY$;



/* ---- Populating user table with default users. ---- */
SELECT public.registeruser('Peter65', '123Piet!@#', 'Peter', 'Schmeical', 'peter65.s@gmail.com','University of Pretoria');
SELECT public.registeruser('John12', 'D0main!', 'John', 'Smith', 'John@live.co.za','University of Pretoria');
SELECT public.registeruser('Blairzee', '!Blairzee', 'Blaire', 'Baldwin', 'Blaire24@gmail.com','University of Pretoria');
SELECT public.registeruser('JohanStemmet', '!stemmet', 'Johan', 'Stemmet', 'manie.gilliland@gmail.com','University of Pretoria');

/* ---- ACCOMODATION TYPES ---- */
INSERT INTO public.AccomodationType(Code,Name,Description,CreatedDateTime,IsDeleted,ModifiedDateTime)
VALUES ('COM', 'Commune', 'A group of people living together and sharing kitchen, bathrooms with their own seperate bedrooms.', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.AccomodationType(Code,Name,Description,CreatedDateTime,IsDeleted,ModifiedDateTime)
VALUES ('APT', 'Appartement', 'A self-contained housing unit (a type of residential real estate) that occupies only part of a building, generally on a single storey.', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.AccomodationType(Code,Name,Description,CreatedDateTime,IsDeleted,ModifiedDateTime)
VALUES ('HSE', 'House', 'A building for human habitation, especially one that consists of a ground floor and one or more upper storeys.', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.AccomodationType(Code,Name,Description,CreatedDateTime,IsDeleted,ModifiedDateTime)
VALUES ('GDC', 'Garden Cottage', 'A small house in the garden of a generally larger house.', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
/* ---- ADVERTISEMENT TYPES ---- */
INSERT INTO public.AdvertisementType (Code,Name,Description,CreatedDateTime,IsDeleted,ModifiedDateTime)
VALUES ('TXB','Textbook', 'A book used for the study of a subject. People use a textbook to learn facts and methods about a certain subject.', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.AdvertisementType (Code,Name,Description,CreatedDateTime,IsDeleted,ModifiedDateTime)
VALUES ('NTS','Notes', 'Notes taken on class lectures about key points or discussions that may serve as study aids.', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.AdvertisementType (Code,Name,Description,CreatedDateTime,IsDeleted,ModifiedDateTime)
VALUES ('TUT','Tutor', 'Tutors are responsible for helping students to understand different subjects. They assess, assist and encourage the students in the learning processes.', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.AdvertisementType (Code,Name,Description,CreatedDateTime,IsDeleted,ModifiedDateTime)
VALUES ('ACD','Accomodation', 'Living quaters provided by privately for public use.', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
/* ---- INSTITUTIONS ---- */
INSERT INTO public.Institution(ID,Name,CreatedDateTime,IsDeleted,ModifiedDateTime)
VALUES ('9d68ff9f-01a0-476e-ac3a-fc6463127ff4', 'University of Pretoria', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Institution(ID,Name,CreatedDateTime,IsDeleted,ModifiedDateTime)
VALUES ('fb901315-d971-4347-880b-bc8c6292386f', 'University of Johannesburg', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
/* ---- FACULTIES ---- */
INSERT INTO public.Faculty(ID,InstitutionID,Name,CreatedDateTime,IsDeleted,ModifiedDateTime)
VALUES ('ec7e55ab-da81-48b1-87df-51d75296297e', '9d68ff9f-01a0-476e-ac3a-fc6463127ff4', 'EMS', CURRENT_TIMESTAMP, false , CURRENT_TIMESTAMP);
INSERT INTO public.Faculty(ID,InstitutionID,Name,CreatedDateTime,IsDeleted,ModifiedDateTime)
VALUES ('79c43f4d-7aff-49bc-bd7d-5b4c630ab7f5', '9d68ff9f-01a0-476e-ac3a-fc6463127ff4', 'ENG', CURRENT_TIMESTAMP, false , CURRENT_TIMESTAMP);
INSERT INTO public.Faculty(ID,InstitutionID,Name,CreatedDateTime,IsDeleted,ModifiedDateTime)
VALUES ('6382b19c-dc86-43d1-8113-b0f765c91e6f', '9d68ff9f-01a0-476e-ac3a-fc6463127ff4', 'LAW', CURRENT_TIMESTAMP, false , CURRENT_TIMESTAMP);
INSERT INTO public.Faculty(ID,InstitutionID,Name,CreatedDateTime,IsDeleted,ModifiedDateTime)
VALUES ('8acca7e9-fdba-4a0f-88f3-1a4cc0c0f32f', 'fb901315-d971-4347-880b-bc8c6292386f', 'EMS', CURRENT_TIMESTAMP, false , CURRENT_TIMESTAMP);
INSERT INTO public.Faculty(ID,InstitutionID,Name,CreatedDateTime,IsDeleted,ModifiedDateTime)
VALUES ('060d4547-65c5-495e-a381-b42107fb632f', 'fb901315-d971-4347-880b-bc8c6292386f', 'ENG', CURRENT_TIMESTAMP, false , CURRENT_TIMESTAMP);
INSERT INTO public.Faculty(ID,InstitutionID,Name,CreatedDateTime,IsDeleted,ModifiedDateTime)
VALUES ('65f21344-e49e-4f29-bccd-a7e39056d3f9', 'fb901315-d971-4347-880b-bc8c6292386f', 'LAW', CURRENT_TIMESTAMP, false , CURRENT_TIMESTAMP);
/* ---- MODULES ---- */
INSERT INTO public.Module(ID,FacultyID,Name,ModuleCode,CreatedDateTime,IsDeleted,ModifiedDateTime)
VALUES ('2e901148-ae96-4158-a92a-3c6f371d1ea1', 'ec7e55ab-da81-48b1-87df-51d75296297e', 'Business Management Basics', 'OBS110', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Module(ID,FacultyID,Name,ModuleCode,CreatedDateTime,IsDeleted,ModifiedDateTime)
VALUES ('e47aa688-d18b-4c88-a93f-ecc5836a88f0', 'ec7e55ab-da81-48b1-87df-51d75296297e', 'Business Management Advanced', 'OBS120', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);

INSERT INTO public.Module(ID,FacultyID,Name,ModuleCode,CreatedDateTime,IsDeleted,ModifiedDateTime)
VALUES ('433ce13a-22ce-4f53-8a75-c7b8e190f15f', '79c43f4d-7aff-49bc-bd7d-5b4c630ab7f5', 'Electrical Engineering Basics', 'ENG111', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Module(ID,FacultyID,Name,ModuleCode,CreatedDateTime,IsDeleted,ModifiedDateTime)
VALUES ('69ba5241-2059-40b0-b02a-7d983d01b6e5', '79c43f4d-7aff-49bc-bd7d-5b4c630ab7f5', 'Electrical Engineering Advanced', 'ENG122', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);

INSERT INTO public.Module(ID,FacultyID,Name,ModuleCode,CreatedDateTime,IsDeleted,ModifiedDateTime)
VALUES ('6168c0d4-a541-450c-9de2-bea7e5be1b00', '6382b19c-dc86-43d1-8113-b0f765c91e6f', 'Family Law Basics', 'LLB120', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Module(ID,FacultyID,Name,ModuleCode,CreatedDateTime,IsDeleted,ModifiedDateTime)
VALUES ('edf58c02-1a51-4188-b21b-f05f82677da8', '6382b19c-dc86-43d1-8113-b0f765c91e6f', 'Family Law Advanced', 'LLB140', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);

INSERT INTO public.Module(ID,FacultyID,Name,ModuleCode,CreatedDateTime,IsDeleted,ModifiedDateTime)
VALUES ('b83a1751-f6bc-466c-b20e-3d837cc22fda', '8acca7e9-fdba-4a0f-88f3-1a4cc0c0f32f', 'Economics Basics', 'EKN110', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Module(ID,FacultyID,Name,ModuleCode,CreatedDateTime,IsDeleted,ModifiedDateTime)
VALUES ('9b137496-d030-4e4d-b85b-2ea334e0179d', '8acca7e9-fdba-4a0f-88f3-1a4cc0c0f32f', 'Economics Advanced', 'EKN122', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);

INSERT INTO public.Module(ID,FacultyID,Name,ModuleCode,CreatedDateTime,IsDeleted,ModifiedDateTime)
VALUES ('d53a2759-0df7-41a4-a8d1-dbbcca3f4f47', '060d4547-65c5-495e-a381-b42107fb632f', 'Chemical Engineering Basics', 'CHE156', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Module(ID,FacultyID,Name,ModuleCode,CreatedDateTime,IsDeleted,ModifiedDateTime)
VALUES ('7c0bc68a-b123-46ca-8d04-d91d7a1c0768', '060d4547-65c5-495e-a381-b42107fb632f', 'Chemical Engineering Advanced', 'CHE186', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);

INSERT INTO public.Module(ID,FacultyID,Name,ModuleCode,CreatedDateTime,IsDeleted,ModifiedDateTime)
VALUES ('15f5d63c-01cf-480c-aadc-335672da87a2', '65f21344-e49e-4f29-bccd-a7e39056d3f9', 'Industrial Law Basics', 'ILB111', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Module(ID,FacultyID,Name,ModuleCode,CreatedDateTime,IsDeleted,ModifiedDateTime)
VALUES ('888b571a-1819-48c8-a8f1-27686b55eb3b', '65f21344-e49e-4f29-bccd-a7e39056d3f9', 'Industrial Law Advanced', 'ILB122', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);

/* ---- TEXTBOOKS ---- */
INSERT INTO public.Textbook(ID, ModuleID, Name, Edition, Quality, Author, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES('382e4fbb-5b63-4a1a-b3ee-162e256e861b','2e901148-ae96-4158-a92a-3c6f371d1ea1', 'Business Strategy Principles', '1', 'Used' , 'Franklin James', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Textbook(ID, ModuleID, Name, Edition, Quality, Author, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES('c05d560b-1ee2-4077-b53c-4c4bea5865cd','2e901148-ae96-4158-a92a-3c6f371d1ea1', 'Business Principles', '2', 'New' , 'Johan Rupert', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Textbook(ID, ModuleID, Name, Edition, Quality, Author, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES('7dda5091-4a6e-42dd-b6e1-7ccc8be7e5cd','e47aa688-d18b-4c88-a93f-ecc5836a88f0', 'Business Strategy Advanced', '1', 'Used' , 'Jon Snow', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Textbook(ID, ModuleID, Name, Edition, Quality, Author, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES('47db44d5-e0ae-4853-93e3-b7c85ff5b65c','e47aa688-d18b-4c88-a93f-ecc5836a88f0', 'Business Advanced', '3', 'Used' , 'Swole Casarole', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Textbook(ID, ModuleID, Name, Edition, Quality, Author, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES('25eceef0-eef4-4ea5-bc06-abc1ffce0b6d','433ce13a-22ce-4f53-8a75-c7b8e190f15f', 'Engineering Principles', '1', 'Used' , 'Isaac Newton', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Textbook(ID, ModuleID, Name, Edition, Quality, Author, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES('0be47249-94f0-463b-bec2-1b80b224c1d3','433ce13a-22ce-4f53-8a75-c7b8e190f15f', 'Calculus Introduction', '4', 'New' , 'Albert Einstein', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Textbook(ID, ModuleID, Name, Edition, Quality, Author, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES('46bd986a-5f7d-4b4a-b972-08518315143b','69ba5241-2059-40b0-b02a-7d983d01b6e5', 'Engineering Advanced', '6', 'Used' , 'Isaac Newton', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Textbook(ID, ModuleID, Name, Edition, Quality, Author, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES('64a4c6c0-bf8e-4728-a650-579003bc6857','69ba5241-2059-40b0-b02a-7d983d01b6e5', 'Calculus Follow-up', '3', 'New' , 'George Shabangu', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);



/* ---- TUTORS ---- */ 
INSERT INTO public.Tutor(ID, Subject, YearCompleted, ModuleID, Venue, NotesIncluded, Terms, CreatedDateTime,IsDeleted,ModifiedDateTime)
VALUES ('0339d90d-bb7b-4054-905a-15feb960f53e', 'Business', '2017', '2e901148-ae96-4158-a92a-3c6f371d1ea1', 'Campus', true, '5 Lessons', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Tutor(ID, Subject, YearCompleted, ModuleID, Venue, NotesIncluded, Terms, CreatedDateTime,IsDeleted,ModifiedDateTime)
VALUES ('07783074-3f1d-4ae3-b27b-c075f34aacf9', 'Business ', '2018', '2e901148-ae96-4158-a92a-3c6f371d1ea1', 'Both', true, 'Pay per Lesson', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Tutor(ID, Subject, YearCompleted, ModuleID, Venue, NotesIncluded, Terms, CreatedDateTime,IsDeleted,ModifiedDateTime)
VALUES ('c184c2b9-4039-4b6f-964c-d95b0b9a358c', 'Business ', '2019', 'e47aa688-d18b-4c88-a93f-ecc5836a88f0', 'Home', true, 'Whole Semester', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Tutor(ID, Subject, YearCompleted, ModuleID, Venue, NotesIncluded, Terms, CreatedDateTime,IsDeleted,ModifiedDateTime)
VALUES ('7e0e437c-aa29-488f-9202-36d281e70c40', 'Engineering', '2016', '433ce13a-22ce-4f53-8a75-c7b8e190f15f', 'Campus', true, '10 Lessons', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Tutor(ID, Subject, YearCompleted, ModuleID, Venue, NotesIncluded, Terms, CreatedDateTime,IsDeleted,ModifiedDateTime)
VALUES ('b8a5ee1b-0696-4d22-8e1d-d325a673980c', 'Engineering', '2017', '69ba5241-2059-40b0-b02a-7d983d01b6e5', 'Home', true, 'Exam Preparations', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Tutor(ID, Subject, YearCompleted, ModuleID, Venue, NotesIncluded, Terms, CreatedDateTime,IsDeleted,ModifiedDateTime)
VALUES ('ddbb68c2-e65c-44dd-a8f1-7c9c0a0a4979', 'Engineering', '2018', '69ba5241-2059-40b0-b02a-7d983d01b6e5', 'Campus', true, 'Contact for details', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);

/* ---- ACCOMODATION ---- */
INSERT INTO public.Accomodation(ID, AccomodationTypeCode, InstitutionID, Location, DistanceToCampus, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('1193447d-5dd6-493f-8b0c-846c88f4e92c', 'APT', '9d68ff9f-01a0-476e-ac3a-fc6463127ff4', 'Hatfield', 1.2, CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Accomodation(ID, AccomodationTypeCode, InstitutionID, Location, DistanceToCampus, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('d4b1ef8d-cac8-4793-96b9-51f1024affc7', 'COM', '9d68ff9f-01a0-476e-ac3a-fc6463127ff4', 'Brooklyn', 2.8, CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Accomodation(ID, AccomodationTypeCode, InstitutionID, Location, DistanceToCampus, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('6032734b-fe59-4be7-b953-c864ad8ac0b7', 'HSE', '9d68ff9f-01a0-476e-ac3a-fc6463127ff4', 'Brooklyn', 4.8, CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Accomodation(ID, AccomodationTypeCode, InstitutionID, Location, DistanceToCampus, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('845f4a14-617b-4010-9dc4-e9cd84f47913', 'GDC', '9d68ff9f-01a0-476e-ac3a-fc6463127ff4', 'PTA CBD', 8.5, CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Accomodation(ID, AccomodationTypeCode, InstitutionID, Location, DistanceToCampus, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('92842317-c6c6-4bac-9b30-aa85fba4af0a', 'APT', 'fb901315-d971-4347-880b-bc8c6292386f', 'JHB CBD', 5.4, CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Accomodation(ID, AccomodationTypeCode, InstitutionID, Location, DistanceToCampus, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('53eaf527-a09b-4fb0-93b7-558ab1e816b0', 'COM', 'fb901315-d971-4347-880b-bc8c6292386f', 'Auckland Park', 0.5, CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Accomodation(ID, AccomodationTypeCode, InstitutionID, Location, DistanceToCampus, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('0a9e2831-1783-4926-8c38-412fba6f7e11', 'HSE', 'fb901315-d971-4347-880b-bc8c6292386f', 'Auckland Park', 8.9, CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Accomodation(ID, AccomodationTypeCode, InstitutionID, Location, DistanceToCampus, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('8bf04861-4b06-4ea5-a0ca-63cc839c3afa', 'GDC', 'fb901315-d971-4347-880b-bc8c6292386f', 'Johannesburg CBD', 1.8, CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);

/* ---- NOTES ---- */
INSERT INTO public.Notes(ID, ModuleID, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('ff3de7fd-1c40-4051-88d3-1c6b14ec894a', '2e901148-ae96-4158-a92a-3c6f371d1ea1', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Notes(ID, ModuleID, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('0d09d6dd-dcb3-4202-80d6-098c2901e14e', '2e901148-ae96-4158-a92a-3c6f371d1ea1', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Notes(ID, ModuleID, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('f654d998-5040-4288-9856-81dd3e713ff2', 'e47aa688-d18b-4c88-a93f-ecc5836a88f0', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Notes(ID, ModuleID, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('dc91d48c-dae9-4cc7-a147-a13c6c133143', 'e47aa688-d18b-4c88-a93f-ecc5836a88f0', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Notes(ID, ModuleID, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('295e33f3-45f1-4440-9737-ba44cbdb50ac', '433ce13a-22ce-4f53-8a75-c7b8e190f15f', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Notes(ID, ModuleID, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('187dcbb0-2ac1-43a0-b6fc-7c687ee756c6', '433ce13a-22ce-4f53-8a75-c7b8e190f15f', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Notes(ID, ModuleID, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('cc795ced-d16c-4cbb-bf8e-712596b4f67d', '69ba5241-2059-40b0-b02a-7d983d01b6e5', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Notes(ID, ModuleID, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('602e0f6f-3277-4348-8111-528286d7c96b', '69ba5241-2059-40b0-b02a-7d983d01b6e5', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);


/* ---- FEATURES ---- */
INSERT INTO public.Feature (Code, Name, Description, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('FBR','Fibre', 'The property is fibre ready.', CURRENT_TIMESTAMP,false,CURRENT_TIMESTAMP);
INSERT INTO public.Feature (Code, Name, Description, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('PAR','Parking', 'The Property has parking.', CURRENT_TIMESTAMP,false,CURRENT_TIMESTAMP);
INSERT INTO public.Feature (Code, Name, Description, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('PPE','Prepaid Electricity', 'The property works on perpaid electricity.', CURRENT_TIMESTAMP,false,CURRENT_TIMESTAMP);
/* ---- USERS ---- */
INSERT INTO public.User(ID,Username,Password,Name,Surname,Email,InstitutionID,CreatedDateTime,IsDeleted,ModifiedDateTime)
VALUES ('56c27ab0-eed7-4aa5-8b0a-e4082c83c3b7','Gerard','1234567','Gerard','Botes','Gerard.Botes@gmail.com', '9d68ff9f-01a0-476e-ac3a-fc6463127ff4', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.User(ID,Username,Password,Name,Surname,Email,InstitutionID,CreatedDateTime,IsDeleted,ModifiedDateTime)
VALUES ('7bb9d62d-c3fa-4e63-9f07-061f6226cebb','Jack','123456','Gerard','Botes','jack@gmail.com', '9d68ff9f-01a0-476e-ac3a-fc6463127ff4', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.User(ID,Username,Password,Name,Surname,Email,InstitutionID,CreatedDateTime,IsDeleted,ModifiedDateTime)
VALUES ('711f58f8-f469-4a44-b83a-7f21d1f24918','James','123456','Gerard','Botes','james@gmail.com', '9d68ff9f-01a0-476e-ac3a-fc6463127ff4', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
/* ---- ADVERTISEMENTS ---- */
INSERT INTO public.Advertisement (ID, UserID, IsSelling, AdvertisementType,EntityID, Price, Description, InstitutionID, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('d17e784f-f5f7-4bc8-ad34-3170bc735fc7', '7bb9d62d-c3fa-4e63-9f07-061f6226cebb', true,'TXB', '382e4fbb-5b63-4a1a-b3ee-162e256e861b', '450','This is business strategy principles, contact now to secure this book which is in amazing condition', '9d68ff9f-01a0-476e-ac3a-fc6463127ff4', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Advertisement (ID, UserID, IsSelling, AdvertisementType,EntityID, Price, Description, InstitutionID, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('9d849400-2320-4133-948c-14241b7ee410', '7bb9d62d-c3fa-4e63-9f07-061f6226cebb', true,'TXB', '64a4c6c0-bf8e-4728-a650-579003bc6857', '300','This is the calculus follow up course textbook! Contact me ASAP, priced to go', '9d68ff9f-01a0-476e-ac3a-fc6463127ff4', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Advertisement (ID, UserID, IsSelling, AdvertisementType,EntityID, Price, Description, InstitutionID, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('155ae020-1499-4e33-aaea-bbd343931cc6', '7bb9d62d-c3fa-4e63-9f07-061f6226cebb', true,'TXB', '7dda5091-4a6e-42dd-b6e1-7ccc8be7e5cd', '500','Business strategy advanced is the subject to do! get this amazing textbook now.', '9d68ff9f-01a0-476e-ac3a-fc6463127ff4', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Advertisement (ID, UserID, IsSelling, AdvertisementType,EntityID, Price, Description, InstitutionID, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('73e8c510-34f3-4fc0-94de-d05d227e1f56', '56c27ab0-eed7-4aa5-8b0a-e4082c83c3b7', true,'TXB', '47db44d5-e0ae-4853-93e3-b7c85ff5b65c', '200','Business implementation! Looking for a fast sell! Selling on Campus! Contact me now!', 'fb901315-d971-4347-880b-bc8c6292386f', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Advertisement (ID, UserID, IsSelling, AdvertisementType,EntityID, Price, Description, InstitutionID, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('a6feb6c0-9349-41f7-ac8e-96e0e0c28148', '56c27ab0-eed7-4aa5-8b0a-e4082c83c3b7', true,'TXB', 'c05d560b-1ee2-4077-b53c-4c4bea5865cd', '765','Great condition, honest sale. Message me for more details. Only cash accepted', 'fb901315-d971-4347-880b-bc8c6292386f', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);



INSERT INTO public.Advertisement (ID, UserID, IsSelling, AdvertisementType,EntityID, Price, Description, InstitutionID, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('06abf31a-3165-48ad-87b3-75ff2a6c0225', '7bb9d62d-c3fa-4e63-9f07-061f6226cebb', true,'TUT', '0339d90d-bb7b-4054-905a-15feb960f53e', '200','Business management will be explained and simplified! contact me for details.', '9d68ff9f-01a0-476e-ac3a-fc6463127ff4', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Advertisement (ID, UserID, IsSelling, AdvertisementType,EntityID, Price, Description, InstitutionID, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('65fffff4-c5a4-4969-b725-7bbd483332df', '7bb9d62d-c3fa-4e63-9f07-061f6226cebb', true,'TUT', '07783074-3f1d-4ae3-b27b-c075f34aacf9', '400','I will simplify this module and help calm the nerves. Notes are included too!', '9d68ff9f-01a0-476e-ac3a-fc6463127ff4', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Advertisement (ID, UserID, IsSelling, AdvertisementType,EntityID, Price, Description, InstitutionID, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('617cca47-49bb-406f-b5e9-adcdde12e5d4', '7bb9d62d-c3fa-4e63-9f07-061f6226cebb', true,'TUT', 'c184c2b9-4039-4b6f-964c-d95b0b9a358c', '250','Within the comfort of your home, you will learn all you need to about this module!', '9d68ff9f-01a0-476e-ac3a-fc6463127ff4', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Advertisement (ID, UserID, IsSelling, AdvertisementType,EntityID, Price, Description, InstitutionID, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('e99605a1-53bb-41f2-81cc-3c8c670f0da7', '56c27ab0-eed7-4aa5-8b0a-e4082c83c3b7', true,'TUT', '7e0e437c-aa29-488f-9202-36d281e70c40', '450','Worried you will now be able to pass ? give me a shout, and we will work through it.', 'fb901315-d971-4347-880b-bc8c6292386f', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Advertisement (ID, UserID, IsSelling, AdvertisementType,EntityID, Price, Description, InstitutionID, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('f17a3666-f7fb-468d-bd2b-b8ad111fc29b', '56c27ab0-eed7-4aa5-8b0a-e4082c83c3b7', true,'TUT', 'ddbb68c2-e65c-44dd-a8f1-7c9c0a0a4979', '150','I was top of my class, we can make that happen for you too, together. Contact me now!', 'fb901315-d971-4347-880b-bc8c6292386f', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);

INSERT INTO public.Advertisement (ID, UserID, IsSelling, AdvertisementType,EntityID, Price, Description, InstitutionID, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('81dc2379-aeb9-4279-865b-bdb46edc5db5', '7bb9d62d-c3fa-4e63-9f07-061f6226cebb', true,'ACD', '1193447d-5dd6-493f-8b0c-846c88f4e92c', '4500','Cozy Hatfield accomodation, right by the gautrain.', '9d68ff9f-01a0-476e-ac3a-fc6463127ff4', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Advertisement (ID, UserID, IsSelling, AdvertisementType,EntityID, Price, Description, InstitutionID, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('4dbe73b4-e811-4a5e-91e0-331d14942067', '7bb9d62d-c3fa-4e63-9f07-061f6226cebb', true,'ACD', 'd4b1ef8d-cac8-4793-96b9-51f1024affc7', '7600','This Brooklyn Commune will make your life easy, on the doorstep on the university.', '9d68ff9f-01a0-476e-ac3a-fc6463127ff4', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Advertisement (ID, UserID, IsSelling, AdvertisementType,EntityID, Price, Description, InstitutionID, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('221cbdbc-9aa4-410b-96a7-26f07dd1ca82', '7bb9d62d-c3fa-4e63-9f07-061f6226cebb', true,'ACD', '845f4a14-617b-4010-9dc4-e9cd84f47913', '5000','This house in the CBD of pretoria will have more than enough room for you and your friends! Drinking is allowed.', '9d68ff9f-01a0-476e-ac3a-fc6463127ff4', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Advertisement (ID, UserID, IsSelling, AdvertisementType,EntityID, Price, Description, InstitutionID, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('d8203552-bf56-4228-9864-cefc3dc957e6', '56c27ab0-eed7-4aa5-8b0a-e4082c83c3b7', true,'ACD', '8bf04861-4b06-4ea5-a0ca-63cc839c3afa', '2750','This apartment in the CBD is very cost effective and is safe', 'fb901315-d971-4347-880b-bc8c6292386f', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Advertisement (ID, UserID, IsSelling, AdvertisementType,EntityID, Price, Description, InstitutionID, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('c9b1d5fa-df6b-4c07-93e6-f5ccaf658501', '56c27ab0-eed7-4aa5-8b0a-e4082c83c3b7', true,'ACD', '1193447d-5dd6-493f-8b0c-846c88f4e92c', '6300','Situated in the heart of Hatfield, UP is a stone throw away.', '9d68ff9f-01a0-476e-ac3a-fc6463127ff4', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);

INSERT INTO public.Advertisement (ID, UserID, IsSelling, AdvertisementType,EntityID, Price, Description, InstitutionID, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('76151522-5437-4fe7-86b9-3dfa11d43cb6', '7bb9d62d-c3fa-4e63-9f07-061f6226cebb', true,'NTS', 'ff3de7fd-1c40-4051-88d3-1c6b14ec894a', '450','These First year OBS notes are all you will need!', '9d68ff9f-01a0-476e-ac3a-fc6463127ff4', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);

INSERT INTO public.Advertisement (ID, UserID, IsSelling, AdvertisementType,EntityID, Price, Description, InstitutionID, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('d3b01bb0-e7b0-4a28-a2af-efda603c78db', '7bb9d62d-c3fa-4e63-9f07-061f6226cebb', true,'NTS', 'ff3de7fd-1c40-4051-88d3-1c6b14ec894a', '150','Selling my amazing notes', '9d68ff9f-01a0-476e-ac3a-fc6463127ff4', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Advertisement (ID, UserID, IsSelling, AdvertisementType,EntityID, Price, Description, InstitutionID, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('3f012de7-6e81-429c-9467-e8f6b7bceb44', '7bb9d62d-c3fa-4e63-9f07-061f6226cebb', true,'NTS', 'ff3de7fd-1c40-4051-88d3-1c6b14ec894a', '100','Selling these notes at a very fair price! My notes are digital so they can be emailed to you', '9d68ff9f-01a0-476e-ac3a-fc6463127ff4', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Advertisement (ID, UserID, IsSelling, AdvertisementType,EntityID, Price, Description, InstitutionID, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('ef3c2429-8a0b-4af7-bc3f-ce8018c475d5', '56c27ab0-eed7-4aa5-8b0a-e4082c83c3b7', true,'NTS', 'ff3de7fd-1c40-4051-88d3-1c6b14ec894a', '75','I made these notes religiously, and aced every paper.', 'fb901315-d971-4347-880b-bc8c6292386f', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);
INSERT INTO public.Advertisement (ID, UserID, IsSelling, AdvertisementType,EntityID, Price, Description, InstitutionID, CreatedDateTime, IsDeleted, ModifiedDateTime)
VALUES ('d50f09da-eeea-4732-a600-479f3ea67477', '56c27ab0-eed7-4aa5-8b0a-e4082c83c3b7', true,'NTS', 'ff3de7fd-1c40-4051-88d3-1c6b14ec894a', '250','These notes are guaranteed to make you pass', 'fb901315-d971-4347-880b-bc8c6292386f', CURRENT_TIMESTAMP, false, CURRENT_TIMESTAMP);







--INSERT DEFAULT IMAGES
INSERT INTO public.AdvertisementImage(AdvertisingID, ImageID, CreatedDateTime, ModifiedDateTime)
VALUES ('d17e784f-f5f7-4bc8-ad34-3170bc735fc7' ,'3f4a9a4c-e9af-4b6a-8f77-7477e144d5e4', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.Image(ID, PathString , FileName, IsMainImage, CreatedDateTime, ModifiedDateTime)
VALUES ('3f4a9a4c-e9af-4b6a-8f77-7477e144d5e4', 'b0bb5a9a-3c6f-48aa-b299-a575b8fd0fe9', 'myimage.png', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO public.AdvertisementImage(AdvertisingID, ImageID, CreatedDateTime, ModifiedDateTime)
VALUES ('d17e784f-f5f7-4bc8-ad34-3170bc735fc7' ,'1c75c652-9ea5-464e-a4ba-8e24c745d041', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.Image(ID, PathString , FileName, IsMainImage, CreatedDateTime, ModifiedDateTime)
VALUES ('1c75c652-9ea5-464e-a4ba-8e24c745d041', '20bae2f7-760e-4df2-9996-094da5dfa072', 'image2.jpeg', false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO public.AdvertisementImage(AdvertisingID, ImageID, CreatedDateTime, ModifiedDateTime)
VALUES ('d17e784f-f5f7-4bc8-ad34-3170bc735fc7' ,'3f0bcedb-29a6-4735-a01c-392d0187cbce', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.Image(ID, PathString , FileName, IsMainImage, CreatedDateTime, ModifiedDateTime)
VALUES ('3f0bcedb-29a6-4735-a01c-392d0187cbce', 'd2a0cca1-6395-4110-8363-5414159e802f', 'image3.jpeg', false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO public.AdvertisementImage(AdvertisingID, ImageID, CreatedDateTime, ModifiedDateTime)
VALUES ('1bd5e0d6-bc54-4806-afe2-8253ceb931d4' ,'e3d7f755-82c8-413a-a597-7de860c18892', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.Image(ID, PathString , FileName, IsMainImage, CreatedDateTime, ModifiedDateTime)
VALUES ('e3d7f755-82c8-413a-a597-7de860c18892', '14c1974d-ce18-45d0-a13e-58ab7919129b', 'myimage.png', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO public.AdvertisementImage(AdvertisingID, ImageID, CreatedDateTime, ModifiedDateTime)
VALUES ('1bd5e0d6-bc54-4806-afe2-8253ceb931d4' ,'4a472bf2-5416-443b-a8b6-5e06a6121332', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.Image(ID, PathString , FileName, IsMainImage, CreatedDateTime, ModifiedDateTime)
VALUES ('4a472bf2-5416-443b-a8b6-5e06a6121332', 'cab574b7-dae0-49d0-bb11-12a966374b26', 'image2.jpeg', false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO public.AdvertisementImage(AdvertisingID, ImageID, CreatedDateTime, ModifiedDateTime)
VALUES ('1bd5e0d6-bc54-4806-afe2-8253ceb931d4' ,'c2b801b3-9faf-42bc-8de7-cad34011d0b8', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.Image(ID, PathString , FileName, IsMainImage, CreatedDateTime, ModifiedDateTime)
VALUES ('c2b801b3-9faf-42bc-8de7-cad34011d0b8', 'c46b896d-8e6d-4d90-bb1f-414cb3e6c61a', 'image3.jpeg', false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO public.AdvertisementImage(AdvertisingID, ImageID, CreatedDateTime, ModifiedDateTime)
VALUES ('d3b01bb0-e7b0-4a28-a2af-efda603c78db' ,'7c278d95-b1a0-41cd-9f87-a922bf260a0c', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.Image(ID, PathString , FileName, IsMainImage, CreatedDateTime, ModifiedDateTime)
VALUES ('7c278d95-b1a0-41cd-9f87-a922bf260a0c', '29c1cc53-0d43-4c45-b550-542781b94392', 'wall', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO public.AdvertisementImage(AdvertisingID, ImageID, CreatedDateTime, ModifiedDateTime)
VALUES ('3f012de7-6e81-429c-9467-e8f6b7bceb44' ,'1c93a0a6-a112-47c6-8843-73cf67e5c83a', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.Image(ID, PathString , FileName, IsMainImage, CreatedDateTime, ModifiedDateTime)
VALUES ('1c93a0a6-a112-47c6-8843-73cf67e5c83a', 'ff74497d-4f43-4132-8340-6af7dfdf6c29', 'image1', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO public.AdvertisementImage(AdvertisingID, ImageID, CreatedDateTime, ModifiedDateTime)
VALUES ('ef3c2429-8a0b-4af7-bc3f-ce8018c475d5' ,'11346a86-97ec-4543-b961-5d9dbb04dd8d', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.Image(ID, PathString , FileName, IsMainImage, CreatedDateTime, ModifiedDateTime)
VALUES ('11346a86-97ec-4543-b961-5d9dbb04dd8d', 'ed7df214-45f4-44f9-8641-a77bc113eb68', 'image2', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO public.AdvertisementImage(AdvertisingID, ImageID, CreatedDateTime, ModifiedDateTime)
VALUES ('d50f09da-eeea-4732-a600-479f3ea67477' ,'0522fa1a-a968-4d48-92cf-a9813c0b1988', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.Image(ID, PathString , FileName, IsMainImage, CreatedDateTime, ModifiedDateTime)
VALUES ('0522fa1a-a968-4d48-92cf-a9813c0b1988', 'c38848d8-e8fc-4a99-8932-e93d5e13c210', 'image3', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO public.AdvertisementImage(AdvertisingID, ImageID, CreatedDateTime, ModifiedDateTime)
VALUES ('9d849400-2320-4133-948c-14241b7ee410' ,'e2f132d6-b0b3-44ea-9344-39f009ecefda', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.Image(ID, PathString , FileName, IsMainImage, CreatedDateTime, ModifiedDateTime)
VALUES ('e2f132d6-b0b3-44ea-9344-39f009ecefda', '66cc856c-1115-40f4-88f9-9db7740ed17b', 'image3', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO public.AdvertisementImage(AdvertisingID, ImageID, CreatedDateTime, ModifiedDateTime)
VALUES ('155ae020-1499-4e33-aaea-bbd343931cc6' ,'2c82c083-a64f-4c13-a761-680a58284b47', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.Image(ID, PathString , FileName, IsMainImage, CreatedDateTime, ModifiedDateTime)
VALUES ('2c82c083-a64f-4c13-a761-680a58284b47', '3f747f7b-425a-4b2a-83d0-2c09794044dc', 'image3', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO public.AdvertisementImage(AdvertisingID, ImageID, CreatedDateTime, ModifiedDateTime)
VALUES ('73e8c510-34f3-4fc0-94de-d05d227e1f56' ,'080d761d-83a3-4d50-9841-63a965ae8edf', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.Image(ID, PathString , FileName, IsMainImage, CreatedDateTime, ModifiedDateTime)
VALUES ('080d761d-83a3-4d50-9841-63a965ae8edf', '3f747f7b-425a-4b2a-83d0-2c09794044dc', 'image3', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO public.AdvertisementImage(AdvertisingID, ImageID, CreatedDateTime, ModifiedDateTime)
VALUES ('a6feb6c0-9349-41f7-ac8e-96e0e0c28148' ,'8c33cb8d-a259-464d-bbf9-bc5bfae9059b', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.Image(ID, PathString , FileName, IsMainImage, CreatedDateTime, ModifiedDateTime)
VALUES ('8c33cb8d-a259-464d-bbf9-bc5bfae9059b', 'db38b9b0-dfb5-45bd-b247-f734414cd6c4', 'image3', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO public.AdvertisementImage(AdvertisingID, ImageID, CreatedDateTime, ModifiedDateTime)
VALUES ('81dc2379-aeb9-4279-865b-bdb46edc5db5' ,'16807e84-ddee-41bc-8719-8cf5865821e8', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.Image(ID, PathString , FileName, IsMainImage, CreatedDateTime, ModifiedDateTime)
VALUES ('16807e84-ddee-41bc-8719-8cf5865821e8', 'f4a29c41-67ab-4dca-9818-2c93f9c26d59', 'image3', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO public.AdvertisementImage(AdvertisingID, ImageID, CreatedDateTime, ModifiedDateTime)
VALUES ('4dbe73b4-e811-4a5e-91e0-331d14942067' ,'49a47104-2735-4cb6-a8af-ec894c966558', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.Image(ID, PathString , FileName, IsMainImage, CreatedDateTime, ModifiedDateTime)
VALUES ('49a47104-2735-4cb6-a8af-ec894c966558', 'd5f993b8-20f5-49fb-b5e2-60de8f27c086', 'image3', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO public.AdvertisementImage(AdvertisingID, ImageID, CreatedDateTime, ModifiedDateTime)
VALUES ('221cbdbc-9aa4-410b-96a7-26f07dd1ca82' ,'2afa404c-c512-4e79-877f-3c066486311d', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.Image(ID, PathString , FileName, IsMainImage, CreatedDateTime, ModifiedDateTime)
VALUES ('2afa404c-c512-4e79-877f-3c066486311d', '9476bb8d-a352-42d8-9634-29b7436ea8ce', 'image3', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO public.AdvertisementImage(AdvertisingID, ImageID, CreatedDateTime, ModifiedDateTime)
VALUES ('d8203552-bf56-4228-9864-cefc3dc957e6' ,'1fd59172-dc66-4a5c-bbe7-90899b3accc4', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.Image(ID, PathString , FileName, IsMainImage, CreatedDateTime, ModifiedDateTime)
VALUES ('1fd59172-dc66-4a5c-bbe7-90899b3accc4', 'ec446f04-8240-40e8-a6bb-117014ab4bc4', 'image3', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO public.AdvertisementImage(AdvertisingID, ImageID, CreatedDateTime, ModifiedDateTime)
VALUES ('c9b1d5fa-df6b-4c07-93e6-f5ccaf658501' ,'301390bc-a7f5-4953-9cff-4263db18d4f5', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.Image(ID, PathString , FileName, IsMainImage, CreatedDateTime, ModifiedDateTime)
VALUES ('301390bc-a7f5-4953-9cff-4263db18d4f5', '3b64723c-f8c2-4b1d-8b1d-8355bdb7f00d', 'image3', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO public.AdvertisementImage(AdvertisingID, ImageID, CreatedDateTime, ModifiedDateTime)
VALUES ('06abf31a-3165-48ad-87b3-75ff2a6c0225' ,'cc2ec1b4-ad94-43d6-afa3-ee3c0e1b88ca', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.Image(ID, PathString , FileName, IsMainImage, CreatedDateTime, ModifiedDateTime)
VALUES ('cc2ec1b4-ad94-43d6-afa3-ee3c0e1b88ca', '772898bf-953b-4d14-b778-8e47ce61c751', 'image3', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO public.AdvertisementImage(AdvertisingID, ImageID, CreatedDateTime, ModifiedDateTime)
VALUES ('65fffff4-c5a4-4969-b725-7bbd483332df' ,'cfb07c4a-45d3-4de4-a487-0efeb6938de7', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.Image(ID, PathString , FileName, IsMainImage, CreatedDateTime, ModifiedDateTime)
VALUES ('cfb07c4a-45d3-4de4-a487-0efeb6938de7', '2cd77ba8-2c49-469d-aead-b92bf516a21f', 'image3', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO public.AdvertisementImage(AdvertisingID, ImageID, CreatedDateTime, ModifiedDateTime)
VALUES ('617cca47-49bb-406f-b5e9-adcdde12e5d4' ,'4acf796d-25bb-4963-b0c0-e8e60fae9b59', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.Image(ID, PathString , FileName, IsMainImage, CreatedDateTime, ModifiedDateTime)
VALUES ('4acf796d-25bb-4963-b0c0-e8e60fae9b59', 'e8211ee3-6f0d-4d6b-9ecd-4003a62865e9', 'image3', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO public.AdvertisementImage(AdvertisingID, ImageID, CreatedDateTime, ModifiedDateTime)
VALUES ('e99605a1-53bb-41f2-81cc-3c8c670f0da7' ,'a5bfa9ef-39da-4155-a7ed-85ef03938d8d', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.Image(ID, PathString , FileName, IsMainImage, CreatedDateTime, ModifiedDateTime)
VALUES ('a5bfa9ef-39da-4155-a7ed-85ef03938d8d', '5dd207e3-a81a-4570-945d-9db45a78c042', 'image3', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO public.AdvertisementImage(AdvertisingID, ImageID, CreatedDateTime, ModifiedDateTime)
VALUES ('f17a3666-f7fb-468d-bd2b-b8ad111fc29b' ,'7082249b-79f9-4e3c-ad57-99560e5876c9', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.Image(ID, PathString , FileName, IsMainImage, CreatedDateTime, ModifiedDateTime)
VALUES ('7082249b-79f9-4e3c-ad57-99560e5876c9', 'd21a12b0-0dc1-4b50-8177-2635f38deba2', 'image3', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO public.AdvertisementImage(AdvertisingID, ImageID, CreatedDateTime, ModifiedDateTime)
VALUES ('76151522-5437-4fe7-86b9-3dfa11d43cb6' ,'2f7b3e95-2836-41bf-a875-8589d1ff6985', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.Image(ID, PathString , FileName, IsMainImage, CreatedDateTime, ModifiedDateTime)
VALUES ('2f7b3e95-2836-41bf-a875-8589d1ff6985', 'a1f6f5cd-cc20-42e1-9572-1286098f1d2c', 'image3', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


/* ---- INSERT CHAT DATA ---- */
INSERT INTO public.Chat(ID, SellerID , BuyerID, AdvertisementType, AdvertisementID, IsActive, CreatedDateTime, ModifiedDateTime)
VALUES ('9924e14c-fa0c-4ae3-9a29-48d3d6f40172', '7bb9d62d-c3fa-4e63-9f07-061f6226cebb', '56c27ab0-eed7-4aa5-8b0a-e4082c83c3b7', 'TXB', 'd17e784f-f5f7-4bc8-ad34-3170bc735fc7', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.Chat(ID, SellerID , BuyerID, AdvertisementType, AdvertisementID, IsActive, CreatedDateTime, ModifiedDateTime)
VALUES ('b08fda22-aa4f-4abc-a8ad-4edb06293212', '7bb9d62d-c3fa-4e63-9f07-061f6226cebb', '711f58f8-f469-4a44-b83a-7f21d1f24918', 'ACD','81dc2379-aeb9-4279-865b-bdb46edc5db5', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


/*---- INSERT MESSAGE DATA ---- */
INSERT INTO public.Message(ID, ChatID , AuthorID, Message, MessageDate, CreatedDateTime, ModifiedDateTime)
VALUES ('1afd7f30-d8bc-4f6a-918a-8998d8a5c333', '9924e14c-fa0c-4ae3-9a29-48d3d6f40172', '56c27ab0-eed7-4aa5-8b0a-e4082c83c3b7', 'Hi, i am interested in your ad', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP );
INSERT INTO public.Message(ID, ChatID , AuthorID, Message, MessageDate, CreatedDateTime, ModifiedDateTime)
VALUES ('d604b46b-edd4-4273-bb6d-9712907fdce4', '9924e14c-fa0c-4ae3-9a29-48d3d6f40172', '7bb9d62d-c3fa-4e63-9f07-061f6226cebb', 'Hello there, does the price work well for you?', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.Message(ID, ChatID , AuthorID, Message, MessageDate, CreatedDateTime, ModifiedDateTime)
VALUES ('2c75f2cf-182d-4d92-84a8-9013381de9c2', 'b08fda22-aa4f-4abc-a8ad-4edb06293212', '711f58f8-f469-4a44-b83a-7f21d1f24918', 'Hello Jack, I would like to get some more details about the hatfield accomodation.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


/* ---- INSERT RATING DATA ---- */
INSERT INTO public.Rating(ID, AdvertisementID , SellerID, BuyerID, BuyerRating, SellerRating, BuyerComments, SellerComments, CreatedDateTime, ModifiedDateTime)
VALUES ('23c571a5-4004-4f98-ac65-d426e022f59a', 'd17e784f-f5f7-4bc8-ad34-3170bc735fc7', '7bb9d62d-c3fa-4e63-9f07-061f6226cebb', '56c27ab0-eed7-4aa5-8b0a-e4082c83c3b7', 4, 4,  'What a person to deal with, he paid in cash too', 'Lovely Guy', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP );
INSERT INTO public.Rating(ID, AdvertisementID , SellerID, BuyerID, SellerRating, SellerComments,  CreatedDateTime, ModifiedDateTime)
VALUES ('efaa90bb-aa53-43ca-8ee2-3a5636579aee', '9d849400-2320-4133-948c-14241b7ee410', '7bb9d62d-c3fa-4e63-9f07-061f6226cebb', '56c27ab0-eed7-4aa5-8b0a-e4082c83c3b7', 5,  'What a person to deal with he accepted cash too', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP );
/* ---- INSERT RATING DATA ---- */
INSERT INTO public.Rating(ID, AdvertisementID , SellerID, BuyerID, BuyerRating, BuyerComments,  CreatedDateTime, ModifiedDateTime)
VALUES ('c524ab86-1d2c-4f7c-a958-348ffa7f625f', '155ae020-1499-4e33-aaea-bbd343931cc6', '56c27ab0-eed7-4aa5-8b0a-e4082c83c3b7', '7bb9d62d-c3fa-4e63-9f07-061f6226cebb', 1,  'What a person to deal with, he paid in cash too', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP );



