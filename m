From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v3] Add "shutdown" to "struct class".
Date: Thu, 25 May 2017 18:09:25 +0200
Message-ID: <20170525160925.GA25318@kroah.com>
References: <20170515173438.13420-1-joshz@google.com>
	<20170525130930.GA16244@kroah.com>
	<CAHSjozAkGo1OnjK8HO3m1YyAwamd4CNZ9rUNiwmBeQz6Gau9VA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHSjozAkGo1OnjK8HO3m1YyAwamd4CNZ9rUNiwmBeQz6Gau9VA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, May 25, 2017 at 08:40:28AM -0700, Josh Zimmerman wrote:
> Thanks, Greg.
> 
> Greg, Jarkko: Do either of you you have any objections to me
> backporting these changes to 4.4 and 4.9? I'd like to make sure that
> at least the couple most recent LTS kernels have this patch.

Why?  What bug does this solve?  If it meets the rules of
Documentation/stable_kernel_rules.txt (or whereever that file moved to),
that's fine with me.

thanks,

greg k-h

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
