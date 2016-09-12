From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: 4b68112 causes 'Could not get TPM timeouts
 anddurations'
Date: Mon, 12 Sep 2016 22:20:01 +0300
Message-ID: <20160912192001.GB17314@intel.com>
References: <OF8C8919AB.C1A2AE5E-ON0025802C.005396B8-8525802C.0053E181@notes.na.collabserv.com>
	<OF094E5F6F.9F1CCCDF-ON0025802C.0056E42F-8525802C.0057EE5F@notes.na.collabserv.com>
	<20160912191331.GA17314@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160912191331.GA17314-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Sep 12, 2016 at 10:13:31PM +0300, Jarkko Sakkinen wrote:
> On Mon, Sep 12, 2016 at 11:59:49AM -0400, Stefan Berger wrote:
> >    Stefan Berger/Watson/IBM@IBMUS wrote on 09/12/2016 11:15:34 AM:
> > 
> >    >
> >    > Patch 4b68112 seems like an unlikely candidate for such a failure,
> >    > nevertheless that's what I am seeing: 'Could not get TPM timeouts
> >    > and durations'.
> > 
> >    Actually, the patch seems to be quite broken. tpm_cmd is being read from
> >    after calling tpm1_getcap_cmd(), but tpm_cmd is not passed to that
> >    function, so it wasn't touched. I am not sure how this was intended to
> >    work and where the check for the returned size was going to be done.
> 
> I will drop this commit. My bad. I looked my only test machine with
> TPM 1.x and the commit was not applied in the test kernel.
> 
> I'll resend this after the pull request after I've done proper testing.
> Can you check it out then?

It's now dropped from the master branch. Can you check that things
work for you before I send the pull request? Thank you for reporting
this and sorry for the inconvience.

/Jarkko

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity 
planning reports. http://sdm.link/zohodev2dev
