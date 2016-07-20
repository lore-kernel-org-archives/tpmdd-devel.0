From: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v2] tpm: add sysfs attributes for tpm2
Date: Wed, 20 Jul 2016 10:41:25 -0700
Message-ID: <20160720174125.GA45696@apronin>
References: <1468547496-16215-1-git-send-email-apronin@chromium.org>
	<e084dfe4f1865aed1a38376f5ce4731fe52030d4.1468982816.git.apronin@chromium.org>
	<20160720170553.GD21460@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160720170553.GD21460-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, smbarber-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, groeck-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jul 20, 2016 at 11:05:53AM -0600, Jason Gunthorpe wrote:
> On Tue, Jul 19, 2016 at 07:51:52PM -0700, Andrey Pronin wrote:
> > Add sysfs attributes in TPM2.0 case for:
> >  - TPM_PT_PERMANENT flags
> >  - TPM_PT_STARTUP_CLEAR flags
> >  - lockout-related properties
> 
> I'm not completely sure we need to have these sysfs attributes. Do you
> have a reason to expose them? Does udev do something based on them? Is
> it just for debugging?
> 
> Otherwise it looks about right to me.
> 

In practice, useful for scripts that monitor in what state
the system started, was there a lockout, can we use tpm for
attestation, can we rely on data stored in NVRAM, etc. And
then interact with the user accordingly.

I don't know of udev rules that do anything based on them,
but in a multi-tpm system, I can envision one that selects
the tpm that was actually used by firmware as the primary one,
or controls permissions for the device based on the state it's
in.

For TPM1.2 we expose some flags from TPM_PERMANENT_FLAGS and
TPM_CAP_PROP_OWNER, for example, to show if the tpm is owned,
enabled etc. A combination of ph/eh/shEnable and *AuthSet flags
from TPM2 provides info allowing to make similar decisions about
the tpm being 'owned' or 'enabled' for userland scripts.

Andrey

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
