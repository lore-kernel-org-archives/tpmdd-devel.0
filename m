From: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: What does error code 38 mean?
Date: Wed, 26 Apr 2017 13:52:37 -0400
Message-ID: <odqmou$d4o$1@blaine.gmane.org>
References: <trinity-decde0f7-fedc-4dc2-b8e0-87a910625951-1492997557494@msvc-mesg-gmx108>
	<0603ee8e-ce81-9a46-4bb3-5fe4d7bda463@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <0603ee8e-ce81-9a46-4bb3-5fe4d7bda463-KUpvgZVWgV9o1qOY/usvUg@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 4/24/2017 10:50 AM, Paul Menzel wrote:
>
> Thank you for the quick reply. As this is during resume, could you
> please point me to documentation, what is expected for resume from the
> firmware?

If "resume" means: from the sleep state where the platform suspends to 
RAM and there is no OS reboot, that's

Shutdown(STATE) followed by Startup(STATE).

The TPM 2.0 specifications use the key word "TPM Resume".



------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
