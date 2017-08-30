From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH RESEND 3/3] tpm-chip: Export TPM device to
 user space even when startup failed
Date: Wed, 30 Aug 2017 13:15:10 +0300
Message-ID: <20170830101510.rlkh2p3zecfsrhgl@linux.intel.com>
References: <20170824083714.10016-1-Alexander.Steffen@infineon.com>
 <20170824083714.10016-4-Alexander.Steffen@infineon.com>
 <20170825172021.lw3ycxqw63ubrcm2@linux.intel.com>
 <adaaeae32ba64d979abfc4b758c63fc0@MUCSE603.infineon.com>
 <20170829125509.55aylht3ikes3bpy@linux.intel.com>
 <20170829151739.315ae581@kitsune.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170829151739.315ae581-6hIufAJW0g4CVLCxKZUutA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek-l3A5Bk7waGM@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Aug 29, 2017 at 03:17:39PM +0200, Michal Such=E1nek wrote:
> Hello,
> =

> On Tue, 29 Aug 2017 15:55:09 +0300
> Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> =

> > On Mon, Aug 28, 2017 at 05:15:58PM +0000,
> > Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org wrote:
> > > But is that just because nobody bothered to implement the necessary
> > > logic or for some other reason?  =

> > =

> > We do not want user space to access broken hardware. It's a huge risk
> > for system stability and potentially could be used for evil purposes.
> > =

> > This is not going to mainline as it is not suitable for general
> > consumption. You must use a patched kernel if you want this.
> > =

> > /Jarkko
> > =

> =

> It has been pointed out that userspace applications that use direct IO
> access exist for the purpose. So using a kernel driver is an
> improvement over that if the interface is otherwise sane.
> =

> What do you expect is the potential for instability or evil use?

By definition the use of broken hardware can have unpredictable effects.
Use a patched kernel if you want to do it.

/Jarkko

---------------------------------------------------------------------------=
---
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
