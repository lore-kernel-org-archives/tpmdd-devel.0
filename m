From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3] Add "shutdown" to "struct class".
Date: Thu, 25 May 2017 15:40:11 -0700
Message-ID: <20170525224011.whm56yzautdo74cj@intel.com>
References: <20170515173438.13420-1-joshz@google.com>
	<20170525130930.GA16244@kroah.com>
	<CAHSjozAkGo1OnjK8HO3m1YyAwamd4CNZ9rUNiwmBeQz6Gau9VA@mail.gmail.com>
	<20170525160925.GA25318@kroah.com>
	<CAHSjozC4N7ShgCqNPbvycrhe17e3NKVik92Gy0vAHqBvBm-oAA@mail.gmail.com>
	<20170525164118.GA28995@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170525164118.GA28995-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Josh,

On Thu, May 25, 2017 at 06:41:18PM +0200, Greg Kroah-Hartman wrote:
> On Thu, May 25, 2017 at 09:24:30AM -0700, Josh Zimmerman wrote:
> > On Thu, May 25, 2017 at 9:09 AM, Greg Kroah-Hartman
> > <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
> > > On Thu, May 25, 2017 at 08:40:28AM -0700, Josh Zimmerman wrote:
> > >> Thanks, Greg.
> > >>
> > >> Greg, Jarkko: Do either of you you have any objections to me
> > >> backporting these changes to 4.4 and 4.9? I'd like to make sure that
> > >> at least the couple most recent LTS kernels have this patch.
> > >
> > > Why?  What bug does this solve?
> > If a TPM2 device has power removed without a TPM2_Shutdown being
> > issued, it will increment its "dictionary attack" counter. After that
> > counter reaches a certain value, the TPM2 device will lock the user
> > out. Adding the shutdown callback allows the TPM kernel driver to send
> > TPM2_Shutdown to all TPM2 devices.
> 
> Is all of that in the tpm patch description?  If so, great, if not,
> please add it.
> 
> > > If it meets the rules of
> > > Documentation/stable_kernel_rules.txt (or whereever that file moved to),
> > > that's fine with me.
> > Documentation/process/stable-kernel-rules.rst, right? To comply with
> > option 1 referred to there (Adding the appropriate "Cc:" to the
> > description), should I send a new patch email or just reply to this
> > one and quote the relevant part? (I don't believe the document
> > specifies.)
> 
> You (or who ever applies these patches) needs to add the cc: stable tag
> to them.  I suggest resend these, as a patch series, with that in it, so
> that it all makes more sense and the tpm maintainer has an easy job of
> it.
> 
> thanks,
> 
> greg k-h

Can you send one more patch set with these two patches and Cc-tags and
refined descriptions where needed. If you do this, I will apply them to
my tree and send PR to James Morris. Thank you.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
