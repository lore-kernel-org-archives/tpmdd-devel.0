From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm_crb: request and relinquish locality 0
Date: Sat, 11 Mar 2017 10:15:32 +0200
Message-ID: <20170311081532.qfxwrx3xqjzoppa2@intel.com>
References: <20170310235802.30765-1-jarkko.sakkinen@linux.intel.com>
	<20170311002709.GA14174@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170311002709.GA14174-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, gang.wei-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Mar 10, 2017 at 05:27:09PM -0700, Jason Gunthorpe wrote:
> On Sat, Mar 11, 2017 at 01:58:00AM +0200, Jarkko Sakkinen wrote:
> > Added two new callbacks to struct tpm_class_ops:
> > 
> > - request_locality
> > - relinquish_locality
> > 
> > These are called before sending and receiving data from the TPM.
> 
> If we are going to add new ops, I think we should also adjust the
> existing drivers to use this mechanism as well?
> 
> eg tis just calls its request_locality as the first thing in send..
> 
> Jason

Would it be sufficient to adjust tpm_tis in addition to tpm_crb? Those
are the only once where I can edit edit-compile-run cycle.

The original commit I did worked on SKL platform that I tested but fails
on KBL but keeping the locality throughout the transmit makes it stable
on every platform I've tested.

/Jarkko

------------------------------------------------------------------------------
Announcing the Oxford Dictionaries API! The API offers world-renowned
dictionary content that is easy and intuitive to access. Sign up for an
account today to start using our lexical data to power your apps and
projects. Get started today and enter our developer competition.
http://sdm.link/oxford
