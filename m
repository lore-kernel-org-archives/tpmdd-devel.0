From: Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>
Subject: Re: Documentation: tpm: Adds the TPM device tree node documentation
Date: Tue, 30 Aug 2016 22:51:56 +0200
Message-ID: <20160830205156.GA31948@katana>
References: <1472532277-21933-1-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1472532277-21933-1-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hellerda-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, ltcgcw-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, gcwilson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 30, 2016 at 12:44:37AM -0400, Nayna Jain wrote:
> This is documenting device tree binding for
> I2C based TPM, similar concept which being used
> for virtual TPM on POWER7 and POWER8 systems running PowerVM.
>=20
> Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---
>  Documentation/devicetree/bindings/i2c/i2c-tpm.txt | 29 +++++++++++++++++=
++++++

Is the driver in 'drivers/i2c/*'? No, so the binding shouldn't be in i2c
as well.

> +- compatible : 'manufacturer,model'

You need to specify them here!

> +Optional properties:
> +
> +- status: indicates whether the device is enabled or disabled. "okay" for
> +          enabled and "disabled" for disabled.

Optional? Rather "implicit" I'd say.

This is far from ready. You should really wait for Rob's review. Or
better: Have a look at other bindings.


--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXxfHsAAoJEBQN5MwUoCm216AP/2ykfd1BzMMquv9yH07veqHb
ow8zAhzV5v7mRUXC4ezVt9WU2KYpv4U6OXj4J45ONJASne3XJnTeSjqz6jGXZJZy
E3ET1+xHEEhvTGlWKcRkLFfDsD7VSKeQ7VfkznCQYwIOFBQFCjzhXJkhZ5CxSYAY
J7uu6CUjG05I7JLYgJ1cQ9xeVb8W+EO9204CmLFj4MMuHp+tbBBsB/cc/cLGNepa
38ItuZuYPM4/VD/qWqjYk++29B0fLQ3OwAtgaq5p4D+1KZgUINLYFpJxSg0zGMg7
b2tgw5GVgHuU+/+gwm/aPjQVrad4oVCItqi0/9VpH43WZ9lU4WHKfnhu/awYBC1b
yF6gkE+CLKfvoqMuuEsaYWYhGV1w0H4c0/KLJ62s+Qu7Oh0LsC3aiJltnpl0Cac5
seNnq1Nc86iI0lKK85CuFzvtvRZ0D3GXe/20LTnPbjzf9lKmTU+kCPAHA0gnJDOe
jXkwYhhv4Q9hw+w5Dg8WvtXfCLUSrdqcpkLeWxLqav5h2Yj5uhOShBg4YcbrgrXO
hyMS6apnpy2suVzmSvFq1GB5ulafJcdlJaV5hIq89M6V2lBQMBDA38LXzjzpHzTb
drguaYnaNxXQBjllxUbQvecgnpuIoTr9Dp44TYvZF+knsbrM+g+8hTJ28/xKllU5
iYNRLMN1syKKOV1nm0Em
=iTjI
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
